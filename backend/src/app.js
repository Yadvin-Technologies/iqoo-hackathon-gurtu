'use strict';

const express = require('express');
const { requireDevice } = require('./auth');
const { BadRequest } = require('./validate');
const { pushEnabled } = require('./push');
const devicesRouter = require('./routes/devices');
const circlesRouter = require('./routes/circles');
const remindersRouter = require('./routes/reminders');

/** The HTTP API. Separate from index.js so tests can run it on any db. */
function createApp({ cols, defaultTimeZone = 'Asia/Kolkata' }) {
  const app = express();
  app.disable('x-powered-by');
  app.set('trust proxy', 1);
  app.use(express.json({ limit: '32kb' }));

  const auth = requireDevice(cols);

  app.get('/health', (_req, res) => res.json({ ok: true, push: pushEnabled() }));
  app.use('/v1/devices', devicesRouter({ cols, auth }));
  app.use('/v1/circles', circlesRouter({ cols, auth }));
  app.use('/v1', remindersRouter({ cols, auth, defaultTimeZone }));

  app.use((_req, res) => res.status(404).json({ error: 'not_found' }));

  // Express 5 sends errors thrown in async handlers here.
  // eslint-disable-next-line no-unused-vars
  app.use((err, req, res, _next) => {
    if (err instanceof BadRequest) {
      return res.status(400).json({ error: 'bad_request', field: err.field, reason: err.reason });
    }
    if (err.type === 'entity.parse.failed' || err.type === 'entity.too.large') {
      return res.status(400).json({ error: 'bad_request' });
    }
    console.error(`[api] ${req.method} ${req.path}:`, err);
    res.status(500).json({ error: 'server_error' });
  });

  return app;
}

module.exports = { createApp };
