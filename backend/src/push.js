'use strict';

const fs = require('fs');
const path = require('path');
const { initializeApp, cert, applicationDefault, getApps, getApp } = require('firebase-admin/app');
const { getMessaging } = require('firebase-admin/messaging');

let messaging = null;

/**
 * Firebase Admin needs a service account (a private key, not the web config
 * the app uses). Without one the server still runs; pushes are skipped and
 * logged.
 */
function initPush({ serviceAccountPath, serviceAccountJson, projectId }) {
  try {
    let serviceAccount = null;
    if (serviceAccountJson) {
      serviceAccount = JSON.parse(serviceAccountJson);
    } else if (serviceAccountPath && fs.existsSync(path.resolve(serviceAccountPath))) {
      serviceAccount = JSON.parse(fs.readFileSync(path.resolve(serviceAccountPath), 'utf8'));
    }
    const credential = serviceAccount
      ? cert(serviceAccount)
      : process.env.GOOGLE_APPLICATION_CREDENTIALS
        ? applicationDefault()
        : null;
    if (!credential) {
      console.warn(
        '[push] No Firebase service account: notifications are disabled. ' +
          'Put serviceAccountKey.json in backend/ (see .env.example).',
      );
      return false;
    }
    const app = getApps().length
      ? getApp()
      : initializeApp({ credential, projectId: projectId || serviceAccount?.project_id });
    messaging = getMessaging(app);
    console.log('[push] Firebase Cloud Messaging ready');
    return true;
  } catch (e) {
    console.error('[push] Firebase Admin failed to start:', e.message);
    messaging = null;
    return false;
  }
}

const pushEnabled = () => messaging !== null;

const DEAD_TOKEN = new Set([
  'messaging/registration-token-not-registered',
  'messaging/invalid-registration-token',
  'messaging/invalid-argument',
]);

/**
 * Sends one notification to [devices] (documents with fcmToken). Tokens the
 * phone no longer accepts are removed so they aren't tried again.
 */
async function sendToDevices(cols, devices, { title, body, data = {} }) {
  const withToken = devices.filter((d) => d.fcmToken);
  if (!withToken.length) return { sent: 0, failed: 0, skipped: devices.length };
  if (!messaging) {
    console.warn(`[push] skipped (disabled): "${title}" to ${withToken.length} device(s)`);
    return { sent: 0, failed: 0, skipped: devices.length, disabled: true };
  }
  const stringData = Object.fromEntries(
    Object.entries(data).map(([k, v]) => [k, String(v)]),
  );
  let sent = 0;
  let failed = 0;
  // FCM takes at most 500 tokens per call.
  for (let i = 0; i < withToken.length; i += 500) {
    const batch = withToken.slice(i, i + 500);
    const res = await messaging.sendEachForMulticast({
      tokens: batch.map((d) => d.fcmToken),
      notification: { title, body },
      data: stringData,
      android: { priority: 'high', notification: { sound: 'default' } },
      apns: { payload: { aps: { sound: 'default' } } },
    });
    sent += res.successCount;
    failed += res.failureCount;
    const dead = [];
    res.responses.forEach((r, j) => {
      if (!r.success && DEAD_TOKEN.has(r.error?.code)) dead.push(batch[j]._id);
    });
    if (dead.length) {
      await cols.devices.updateMany(
        { _id: { $in: dead } },
        { $unset: { fcmToken: '' }, $set: { tokenInvalidAt: new Date() } },
      );
    }
  }
  return { sent, failed, skipped: devices.length - withToken.length };
}

/** Every device of a circle's members, except [exceptDeviceId]. */
async function circleDevices(cols, circleId, { exceptDeviceId, memberIds } = {}) {
  const filter = { circleId, deviceId: { $type: 'string' } };
  if (memberIds?.length) filter._id = { $in: memberIds };
  const members = await cols.members.find(filter).toArray();
  const ids = members.map((m) => m.deviceId).filter((id) => id !== exceptDeviceId);
  if (!ids.length) return [];
  return cols.devices.find({ _id: { $in: ids } }).toArray();
}

module.exports = { initPush, pushEnabled, sendToDevices, circleDevices };
