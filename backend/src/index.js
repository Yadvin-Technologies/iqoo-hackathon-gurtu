'use strict';

const config = require('./config');
const { connect } = require('./db');
const { createApp } = require('./app');
const { initPush } = require('./push');
const { startReminderCron } = require('./reminders');

async function main() {
  const { client, cols } = await connect(config.mongoUri(), config.mongoDb);
  console.log(`[db] connected to "${config.mongoDb}"`);
  initPush(config.firebase);
  const cron = startReminderCron(cols);

  const app = createApp({ cols, defaultTimeZone: config.defaultTimeZone });
  // 0.0.0.0 so a phone on the same Wi-Fi can reach it during development.
  const server = app.listen(config.port, '0.0.0.0', () => {
    console.log(`[api] listening on http://0.0.0.0:${config.port}`);
  });

  const shutdown = async (signal) => {
    console.log(`[api] ${signal}: shutting down`);
    cron.stop();
    server.close();
    await client.close();
    process.exit(0);
  };
  process.on('SIGINT', () => shutdown('SIGINT'));
  process.on('SIGTERM', () => shutdown('SIGTERM'));
}

main().catch((e) => {
  console.error('[api] failed to start:', e.message);
  process.exit(1);
});
