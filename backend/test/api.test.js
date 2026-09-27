'use strict';

// End to end against a real MongoDB (MONGODB_URI from .env), in a throwaway
// database that is dropped afterwards. Skipped when no URI is set.

const test = require('node:test');
const assert = require('node:assert');
const crypto = require('crypto');
require('dotenv').config({ quiet: true, path: require('path').join(__dirname, '..', '.env') });

const { connect } = require('../src/db');
const { createApp } = require('../src/app');
const { runDueReminders } = require('../src/reminders');

const uri = process.env.MONGODB_URI;

test('Gurtu API', { skip: !uri && 'MONGODB_URI not set' }, async (t) => {
  const dbName = `gurtu_test_${crypto.randomBytes(4).toString('hex')}`;
  const { client, db, cols } = await connect(uri, dbName);
  const server = createApp({ cols }).listen(0);
  const base = `http://127.0.0.1:${server.address().port}`;

  t.after(async () => {
    server.close();
    await db.dropDatabase();
    await client.close();
  });

  async function call(method, path, { token, body } = {}) {
    const res = await fetch(base + path, {
      method,
      headers: {
        'content-type': 'application/json',
        ...(token ? { authorization: `Bearer ${token}` } : {}),
      },
      body: body === undefined ? undefined : JSON.stringify(body),
    });
    return { status: res.status, body: await res.json() };
  }

  const owner = await call('POST', '/v1/devices', {
    body: { fcmToken: 'token-owner', platform: 'android', language: 'te' },
  });
  const sister = await call('POST', '/v1/devices', {
    body: { fcmToken: 'token-sister', platform: 'android', language: 'hi' },
  });
  const stranger = await call('POST', '/v1/devices', { body: { platform: 'android' } });

  await t.test('devices get a token; bad tokens are refused', async () => {
    assert.strictEqual(owner.status, 201);
    assert.match(owner.body.token, /^[0-9a-f-]{36}\.[A-Za-z0-9_-]+$/);
    const stored = await cols.devices.findOne({ _id: owner.body.deviceId });
    assert.strictEqual(stored.fcmToken, 'token-owner');
    assert.ok(!JSON.stringify(stored).includes(owner.body.token.split('.')[1]));
    const forged = `${owner.body.deviceId}.${'x'.repeat(43)}`;
    assert.strictEqual((await call('GET', '/v1/circles/any', { token: forged })).status, 401);
    assert.strictEqual((await call('GET', '/v1/circles/any')).status, 401);
  });

  let circle;
  await t.test('onboarding saves the patient and gives a 6-digit code', async () => {
    const res = await call('POST', '/v1/circles', {
      token: owner.body.token,
      body: {
        patientIsMe: false,
        me: { name: 'Sai', role: 'caregiver' },
        patient: {
          name: 'Amma',
          age: 64,
          gender: 'female',
          conditions: ['diabetes', 'highBp'],
          allergies: [],
          careFor: 'parent',
        },
      },
    });
    assert.strictEqual(res.status, 201);
    circle = res.body;
    assert.match(circle.code, /^[1-9]\d{5}$/);
    assert.strictEqual(circle.patient.name, 'Amma');
    assert.deepStrictEqual(circle.patient.conditions, ['diabetes', 'highBp']);
    assert.deepStrictEqual(
      circle.members.map((m) => [m.name, m.role, m.isYou, m.usesApp]),
      [
        ['Sai', 'caregiver', true, true],
        ['Amma', 'patient', false, false],
      ],
    );
    assert.ok(circle.me.isOwner);
  });

  await t.test('bad input is refused with the field named', async () => {
    const res = await call('POST', '/v1/circles', {
      token: owner.body.token,
      body: { patient: { name: '' }, me: { name: 'Sai' } },
    });
    assert.strictEqual(res.status, 400);
    assert.strictEqual(res.body.field, 'patient.name');
  });

  await t.test('family joins with the code; strangers cannot see the circle', async () => {
    assert.strictEqual(
      (await call('GET', `/v1/circles/${circle.id}`, { token: stranger.body.token })).status,
      404,
    );
    const wrong = await call('POST', '/v1/circles/join', {
      token: sister.body.token,
      body: { code: circle.code === '111111' ? '222222' : '111111', name: 'Anu' },
    });
    assert.strictEqual(wrong.status, 404);
    assert.strictEqual(wrong.body.error, 'invalid_code');

    const joined = await call('POST', '/v1/circles/join', {
      token: sister.body.token,
      body: { code: circle.code, name: 'Anu', role: 'family' },
    });
    assert.strictEqual(joined.status, 200);
    assert.strictEqual(joined.body.id, circle.id);
    assert.strictEqual(joined.body.patient.name, 'Amma');
    assert.strictEqual(joined.body.members.length, 3);
    assert.ok(joined.body.members.find((m) => m.name === 'Anu').isYou);

    // Joining again does not add a second Anu.
    const again = await call('POST', '/v1/circles/join', {
      token: sister.body.token,
      body: { code: circle.code, name: 'Anu' },
    });
    assert.strictEqual(again.body.members.length, 3);

    const seen = await call('GET', `/v1/circles/${circle.id}`, { token: owner.body.token });
    assert.ok(seen.body.members.every((m) => m.name !== 'Anu' || m.notificationsOn));
  });

  await t.test('only the owner can change the code', async () => {
    const denied = await call('POST', `/v1/circles/${circle.id}/code`, {
      token: sister.body.token,
    });
    assert.strictEqual(denied.status, 403);
    const rotated = await call('POST', `/v1/circles/${circle.id}/code`, {
      token: owner.body.token,
    });
    assert.strictEqual(rotated.status, 200);
    assert.notStrictEqual(rotated.body.code, circle.code);
    circle = rotated.body;
  });

  await t.test('guessing codes is rate limited', async () => {
    let last;
    for (let i = 0; i < 11; i++) {
      last = await call('POST', '/v1/circles/join', {
        token: stranger.body.token,
        body: { code: '100000', name: 'X' },
      });
    }
    assert.strictEqual(last.status, 429);
  });

  await t.test('a new FCM token replaces the old one', async () => {
    const res = await call('PUT', '/v1/devices/me', {
      token: sister.body.token,
      body: { fcmToken: 'token-sister-2', language: 'te' },
    });
    assert.strictEqual(res.status, 200);
    const stored = await cols.devices.findOne({ _id: sister.body.deviceId });
    assert.strictEqual(stored.fcmToken, 'token-sister-2');
    assert.strictEqual(stored.language, 'te');
  });

  await t.test('reminders are scheduled and claimed once by the cron', async () => {
    const created = await call('POST', `/v1/circles/${circle.id}/reminders`, {
      token: owner.body.token,
      body: { title: 'Metformin', body: 'After breakfast', time: '08:00', repeat: 'daily' },
    });
    assert.strictEqual(created.status, 201);
    assert.strictEqual(created.body.timezone, 'Asia/Kolkata');
    assert.ok(new Date(created.body.nextRunAt) > new Date());

    const bad = await call('POST', `/v1/circles/${circle.id}/reminders`, {
      token: owner.body.token,
      body: { title: 'x', time: '25:00' },
    });
    assert.strictEqual(bad.status, 400);
    assert.strictEqual(bad.body.field, 'time');

    // Make it due a minute ago, then run the job twice.
    const due = new Date(Date.now() - 60 * 1000);
    await cols.reminders.updateOne({ _id: created.body.id }, { $set: { nextRunAt: due } });
    const first = await runDueReminders(cols);
    const second = await runDueReminders(cols);
    assert.strictEqual(first.due, 1);
    assert.strictEqual(second.due, 0);
    const after = await cols.reminders.findOne({ _id: created.body.id });
    assert.ok(after.nextRunAt > new Date());
    assert.ok(after.active);
    assert.ok(after.lastResult);

    const listed = await call('GET', `/v1/circles/${circle.id}/reminders`, {
      token: sister.body.token,
    });
    assert.strictEqual(listed.body.reminders.length, 1);
    const removed = await call('DELETE', `/v1/reminders/${created.body.id}`, {
      token: stranger.body.token,
    });
    assert.strictEqual(removed.status, 404);
  });

  await t.test('leaving hands ownership on; the last one out closes it', async () => {
    await call('DELETE', `/v1/circles/${circle.id}/members/me`, { token: owner.body.token });
    const seen = await call('GET', `/v1/circles/${circle.id}`, { token: sister.body.token });
    assert.ok(seen.body.me.isOwner);
    await call('DELETE', `/v1/circles/${circle.id}/members/me`, { token: sister.body.token });
    assert.strictEqual(await cols.circles.countDocuments({ _id: circle.id }), 0);
    assert.strictEqual(await cols.members.countDocuments({ circleId: circle.id }), 0);
  });
});
