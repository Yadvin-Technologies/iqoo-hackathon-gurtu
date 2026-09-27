'use strict';

const express = require('express');
const { newDeviceCredentials } = require('../auth');
const { text, oneOf } = require('../validate');
const { isValidTimeZone } = require('../time');

function deviceFields(body) {
  const fields = {};
  if (body.fcmToken !== undefined) {
    const token = text(body.fcmToken, 'fcmToken', { max: 4096 });
    fields.fcmToken = token || undefined;
  }
  if (body.platform !== undefined) {
    fields.platform = oneOf(body.platform, 'platform', ['android', 'ios', 'other']);
  }
  if (body.language !== undefined) fields.language = text(body.language, 'language', { max: 10 });
  if (body.appVersion !== undefined) {
    fields.appVersion = text(body.appVersion, 'appVersion', { max: 30 });
  }
  if (body.timezone !== undefined && isValidTimeZone(body.timezone)) {
    fields.timezone = body.timezone;
  }
  return fields;
}

module.exports = function devicesRouter({ cols, auth }) {
  const r = express.Router();

  /** A new install: returns the id and the secret the app signs with. */
  r.post('/', async (req, res) => {
    const fields = deviceFields(req.body || {});
    const creds = newDeviceCredentials();
    const now = new Date();
    const doc = { _id: creds.id, secretHash: creds.secretHash, createdAt: now, updatedAt: now };
    for (const [k, v] of Object.entries(fields)) if (v !== undefined) doc[k] = v;
    await cols.devices.insertOne(doc);
    res.status(201).json({ deviceId: creds.id, token: creds.token });
  });

  /** Keeps the FCM token (it changes now and then) and language current. */
  r.put('/me', auth, async (req, res) => {
    const fields = deviceFields(req.body || {});
    const set = { updatedAt: new Date() };
    const unset = {};
    for (const [k, v] of Object.entries(fields)) {
      if (v === undefined) unset[k] = '';
      else set[k] = v;
    }
    // One token belongs to one install: take it off any other device record.
    if (set.fcmToken) {
      await cols.devices.updateMany(
        { fcmToken: set.fcmToken, _id: { $ne: req.device._id } },
        { $unset: { fcmToken: '' } },
      );
    }
    await cols.devices.updateOne(
      { _id: req.device._id },
      Object.keys(unset).length ? { $set: set, $unset: unset } : { $set: set },
    );
    res.json({ ok: true });
  });

  return r;
};
