'use strict';

const crypto = require('crypto');

const sha256 = (s) => crypto.createHash('sha256').update(s).digest('hex');

/** A new device id and the secret only the app keeps (we store its hash). */
function newDeviceCredentials() {
  const id = crypto.randomUUID();
  const secret = crypto.randomBytes(32).toString('base64url');
  return { id, secret, secretHash: sha256(secret), token: `${id}.${secret}` };
}

/** `Authorization: Bearer <deviceId>.<secret>` → req.device. */
function requireDevice(cols) {
  return async (req, res, next) => {
    const match = /^Bearer ([0-9a-f-]{36})\.([A-Za-z0-9_-]{20,100})$/.exec(
      req.get('authorization') || '',
    );
    if (!match) return res.status(401).json({ error: 'unauthorized' });
    const [, id, secret] = match;
    const device = await cols.devices.findOne({ _id: id });
    const given = Buffer.from(sha256(secret));
    if (!device || !crypto.timingSafeEqual(given, Buffer.from(device.secretHash))) {
      return res.status(401).json({ error: 'unauthorized' });
    }
    req.device = device;
    // Not awaited: a seen-at stamp must never slow a request down.
    cols.devices
      .updateOne({ _id: id }, { $set: { lastSeenAt: new Date() } })
      .catch(() => {});
    next();
  };
}

/**
 * Allows [limit] calls per [windowMs] for each key (device or IP). In memory:
 * enough for one server; move to Redis if the backend is ever scaled out.
 */
function rateLimit({ limit, windowMs, key }) {
  const hits = new Map();
  setInterval(() => {
    const now = Date.now();
    for (const [k, v] of hits) if (v.resetAt <= now) hits.delete(k);
  }, windowMs).unref();
  return (req, res, next) => {
    const k = key(req);
    const now = Date.now();
    let entry = hits.get(k);
    if (!entry || entry.resetAt <= now) {
      entry = { count: 0, resetAt: now + windowMs };
      hits.set(k, entry);
    }
    entry.count += 1;
    if (entry.count > limit) {
      res.set('Retry-After', String(Math.ceil((entry.resetAt - now) / 1000)));
      return res.status(429).json({ error: 'too_many_attempts' });
    }
    next();
  };
}

module.exports = { newDeviceCredentials, requireDevice, rateLimit, sha256 };
