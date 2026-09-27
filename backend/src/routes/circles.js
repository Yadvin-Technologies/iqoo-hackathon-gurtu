'use strict';

const crypto = require('crypto');
const express = require('express');
const { rateLimit } = require('../auth');
const { BadRequest, text, oneOf, ROLES, patientProfile } = require('../validate');
const { circleDevices, sendToDevices } = require('../push');
const { t } = require('../messages');

/** Six random digits, never starting with 0 so it reads as a number. */
const newCode = () => String(crypto.randomInt(100000, 1000000));

/** Tries fresh codes until one is free (the index keeps them unique). */
async function withFreshCode(write) {
  for (let i = 0; i < 8; i++) {
    const code = newCode();
    try {
      await write(code);
      return code;
    } catch (e) {
      if (e?.code !== 11000 || !String(e.message).includes('code')) throw e;
    }
  }
  throw new Error('Could not find a free circle code');
}

/** What the app sees: the circle, its members, and who "you" are. */
async function circleView(cols, circle, deviceId) {
  const members = await cols.members.find({ circleId: circle._id }).sort({ joinedAt: 1 }).toArray();
  const deviceIds = members.map((m) => m.deviceId).filter(Boolean);
  const devices = deviceIds.length
    ? await cols.devices.find({ _id: { $in: deviceIds } }, { projection: { fcmToken: 1 } }).toArray()
    : [];
  const withPush = new Set(devices.filter((d) => d.fcmToken).map((d) => d._id));
  const me = members.find((m) => m.deviceId === deviceId);
  return {
    id: circle._id,
    code: circle.code,
    patient: circle.patient,
    createdAt: circle.createdAt,
    updatedAt: circle.updatedAt,
    me: me ? { memberId: me._id, role: me.role, isOwner: !!me.isOwner } : null,
    members: members.map((m) => ({
      id: m._id,
      name: m.name,
      role: m.role,
      isOwner: !!m.isOwner,
      isYou: m.deviceId === deviceId,
      usesApp: !!m.deviceId,
      notificationsOn: withPush.has(m.deviceId),
      joinedAt: m.joinedAt,
    })),
  };
}

module.exports = function circlesRouter({ cols, auth }) {
  const r = express.Router();
  r.use(auth);

  /** Loads the circle when this device is one of its members. */
  async function membership(req, res) {
    const circle = await cols.circles.findOne({ _id: req.params.id });
    const member =
      circle && (await cols.members.findOne({ circleId: circle._id, deviceId: req.device._id }));
    if (!circle || !member) {
      res.status(404).json({ error: 'not_found' });
      return null;
    }
    return { circle, member };
  }

  /**
   * Saves onboarding: the person cared for, and you. When you are setting
   * it up for someone else, they are added as a member without a device.
   */
  r.post('/', async (req, res) => {
    const body = req.body || {};
    const patient = patientProfile(body.patient);
    const patientIsMe = body.patientIsMe === true;
    const myName = patientIsMe
      ? patient.name
      : text(body.me?.name, 'me.name', { max: 60, required: true });
    const myRole = patientIsMe
      ? 'patient'
      : oneOf(body.me?.role, 'me.role', ROLES.filter((x) => x !== 'patient'), {
          fallback: 'caregiver',
        });
    const now = new Date();
    const circleId = crypto.randomUUID();
    await withFreshCode((code) =>
      cols.circles.insertOne({
        _id: circleId,
        code,
        patient,
        createdByDevice: req.device._id,
        createdAt: now,
        updatedAt: now,
      }),
    );
    const members = [
      {
        _id: crypto.randomUUID(),
        circleId,
        deviceId: req.device._id,
        name: myName,
        role: myRole,
        isOwner: true,
        joinedAt: now,
      },
    ];
    if (!patientIsMe) {
      members.push({
        _id: crypto.randomUUID(),
        circleId,
        deviceId: null,
        name: patient.name,
        role: 'patient',
        isOwner: false,
        joinedAt: now,
      });
    }
    await cols.members.insertMany(members);
    const circle = await cols.circles.findOne({ _id: circleId });
    res.status(201).json(await circleView(cols, circle, req.device._id));
  });

  /** Joins a family with the 6-digit code someone shared. */
  r.post(
    '/join',
    rateLimit({ limit: 10, windowMs: 15 * 60 * 1000, key: (req) => `join:${req.device._id}` }),
    rateLimit({ limit: 30, windowMs: 15 * 60 * 1000, key: (req) => `join-ip:${req.ip}` }),
    async (req, res) => {
      const body = req.body || {};
      const code = String(body.code ?? '').replace(/\s/g, '');
      if (!/^\d{6}$/.test(code)) throw new BadRequest('code');
      const name = text(body.name, 'name', { max: 60, required: true });
      const role = oneOf(body.role, 'role', ROLES.filter((x) => x !== 'patient'), {
        fallback: 'family',
      });
      const circle = await cols.circles.findOne({ code });
      if (!circle) return res.status(404).json({ error: 'invalid_code' });

      const existing = await cols.members.findOne({
        circleId: circle._id,
        deviceId: req.device._id,
      });
      if (!existing) {
        try {
          await cols.members.insertOne({
            _id: crypto.randomUUID(),
            circleId: circle._id,
            deviceId: req.device._id,
            name,
            role,
            isOwner: false,
            joinedAt: new Date(),
          });
        } catch (e) {
          if (e?.code !== 11000) throw e; // Joined twice at once: fine.
        }
        // Tell the others, in each one's language. Not awaited.
        circleDevices(cols, circle._id, { exceptDeviceId: req.device._id })
          .then((devices) =>
            Promise.all(
              devices.map((d) =>
                sendToDevices(cols, [d], {
                  title: t('joinedTitle', d.language),
                  body: t('joinedBody', d.language, { name, patient: circle.patient.name }),
                  data: { type: 'member_joined', circleId: circle._id },
                }),
              ),
            ),
          )
          .catch((e) => console.error('[join] notify failed:', e.message));
      }
      res.json(await circleView(cols, circle, req.device._id));
    },
  );

  r.get('/:id', async (req, res) => {
    const m = await membership(req, res);
    if (m) res.json(await circleView(cols, m.circle, req.device._id));
  });

  /** Profile changes made later (age, conditions...). */
  r.put('/:id/patient', async (req, res) => {
    const m = await membership(req, res);
    if (!m) return;
    const patient = patientProfile(req.body?.patient);
    await cols.circles.updateOne(
      { _id: m.circle._id },
      { $set: { patient, updatedAt: new Date() } },
    );
    const circle = await cols.circles.findOne({ _id: m.circle._id });
    res.json(await circleView(cols, circle, req.device._id));
  });

  /** A new code, when the old one was shared too widely. Owner only. */
  r.post('/:id/code', async (req, res) => {
    const m = await membership(req, res);
    if (!m) return;
    if (!m.member.isOwner) return res.status(403).json({ error: 'owner_only' });
    await withFreshCode((code) =>
      cols.circles.updateOne({ _id: m.circle._id }, { $set: { code, updatedAt: new Date() } }),
    );
    const circle = await cols.circles.findOne({ _id: m.circle._id });
    res.json(await circleView(cols, circle, req.device._id));
  });

  /** Leaves the circle. The last one using the app takes it down with them. */
  r.delete('/:id/members/me', async (req, res) => {
    const m = await membership(req, res);
    if (!m) return;
    await cols.members.deleteOne({ _id: m.member._id });
    const left = await cols.members
      .find({ circleId: m.circle._id, deviceId: { $type: 'string' } })
      .sort({ joinedAt: 1 })
      .toArray();
    if (!left.length) {
      await Promise.all([
        cols.members.deleteMany({ circleId: m.circle._id }),
        cols.reminders.deleteMany({ circleId: m.circle._id }),
        cols.circles.deleteOne({ _id: m.circle._id }),
      ]);
    } else if (m.member.isOwner) {
      await cols.members.updateOne({ _id: left[0]._id }, { $set: { isOwner: true } });
    }
    res.json({ ok: true });
  });

  /** A notification to everyone in the circle (also: "send a test"). */
  r.post(
    '/:id/notify',
    rateLimit({ limit: 6, windowMs: 60 * 1000, key: (req) => `notify:${req.device._id}` }),
    async (req, res) => {
      const m = await membership(req, res);
      if (!m) return;
      const title = text(req.body?.title, 'title', { max: 80, required: true });
      const body = text(req.body?.body, 'body', { max: 300, required: true });
      const devices = await circleDevices(cols, m.circle._id);
      const result = await sendToDevices(cols, devices, {
        title,
        body,
        data: { type: 'message', circleId: m.circle._id, from: m.member.name },
      });
      res.json(result);
    },
  );

  return r;
};

module.exports.circleView = circleView;
