'use strict';

require('dotenv').config({ quiet: true });

function required(name) {
  const value = process.env[name];
  if (!value) throw new Error(`Missing ${name}. Copy .env.example to .env and fill it in.`);
  return value;
}

module.exports = {
  port: Number(process.env.PORT) || 4000,
  mongoUri: () => required('MONGODB_URI'),
  mongoDb: process.env.MONGODB_DB || 'gurtu',
  firebase: {
    serviceAccountPath: process.env.FIREBASE_SERVICE_ACCOUNT_PATH || '',
    // Also accepted base64-encoded: one line, safe to paste into any
    // host's environment settings (Dokploy, Docker).
    serviceAccountJson:
      process.env.FIREBASE_SERVICE_ACCOUNT_JSON ||
      (process.env.FIREBASE_SERVICE_ACCOUNT_BASE64
        ? Buffer.from(process.env.FIREBASE_SERVICE_ACCOUNT_BASE64, 'base64').toString('utf8')
        : ''),
    projectId: process.env.FIREBASE_PROJECT_ID || undefined,
  },
  defaultTimeZone: process.env.DEFAULT_TIMEZONE || 'Asia/Kolkata',
};
