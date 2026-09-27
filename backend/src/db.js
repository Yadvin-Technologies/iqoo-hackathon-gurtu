'use strict';

const { MongoClient } = require('mongodb');

/**
 * Collections:
 *  devices   one per app install: its FCM token and a hashed secret it
 *            signs requests with. No accounts or passwords.
 *  circles   one per person being cared for: their onboarding profile and
 *            the 6-digit code family members join with.
 *  members   who is in a circle, and on which device (none for a patient
 *            who doesn't use the app themselves).
 *  reminders scheduled pushes to a circle, sent by the cron job.
 */
async function connect(uri, dbName) {
  const client = new MongoClient(uri, {
    serverSelectionTimeoutMS: 15000,
    appName: 'gurtu-backend',
  });
  await client.connect();
  const db = client.db(dbName);
  const cols = collections(db);
  await ensureIndexes(cols);
  return { client, db, cols };
}

function collections(db) {
  return {
    devices: db.collection('devices'),
    circles: db.collection('circles'),
    members: db.collection('members'),
    reminders: db.collection('reminders'),
  };
}

async function ensureIndexes(cols) {
  await Promise.all([
    cols.circles.createIndex({ code: 1 }, { unique: true }),
    cols.members.createIndex({ circleId: 1 }),
    cols.members.createIndex({ deviceId: 1 }),
    // A device joins a circle once.
    cols.members.createIndex(
      { circleId: 1, deviceId: 1 },
      { unique: true, partialFilterExpression: { deviceId: { $type: 'string' } } },
    ),
    cols.reminders.createIndex({ active: 1, nextRunAt: 1 }),
    cols.reminders.createIndex({ circleId: 1 }),
    cols.devices.createIndex({ fcmToken: 1 }, { sparse: true }),
  ]);
}

module.exports = { connect, collections, ensureIndexes };
