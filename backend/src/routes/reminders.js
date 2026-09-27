'use strict';

const crypto = require('crypto');
const express = require('express');
const { BadRequest, text, oneOf } = require('../validate');
const { isValidTimeZone, parseDate, parseTime } = require('../time');
const { firstRun } = require('../reminders');

function view(r) {
  return {
    id: r._id,
    circleId: r.circleId,
    title: r.title,
    body: r.body,
    time: r.time,
    timezone: r.timezone,
    repeat: r.repeat,
    date: r.date,
    memberIds: r.memberIds,
    active: r.active,
    nextRunAt: r.nextRunAt,
    lastRunAt: r.lastRunAt,
  };
}

/**
 * Reminders: "08:00 every day" or "on 2026-10-28 at 09:30", pushed to the
 * circle (or chosen members) by the cron job. What they say is up to the
 * app: medicine times, visits, anything.
 */
module.exports = function remindersRouter({ cols, auth, defaultTimeZone }) {
  const r = express.Router();
  r.use(auth);

  async function isMember(circleId, deviceId) {
    return !!(await cols.members.findOne({ circleId, deviceId }));
  }

  function schedule(body, current = {}) {
    const time = body.time ?? current.time;
    if (!parseTime(time)) throw new BadRequest('time');
    const timezone = body.timezone ?? current.timezone ?? defaultTimeZone;
    if (!isValidTimeZone(timezone)) throw new BadRequest('timezone');
    const repeat = oneOf(body.repeat ?? current.repeat, 'repeat', ['daily', 'once'], {
      fallback: 'daily',
    });
    const date = body.date ?? current.date ?? null;
    if (repeat === 'once' && date !== null && !parseDate(date)) throw new BadRequest('date');
    const nextRunAt = firstRun({ time, timezone, repeat, date });
    return { time, timezone, repeat, date, nextRunAt, active: nextRunAt !== null };
  }

  r.get('/circles/:id/reminders', async (req, res) => {
    if (!(await isMember(req.params.id, req.device._id))) {
      return res.status(404).json({ error: 'not_found' });
    }
    const list = await cols.reminders
      .find({ circleId: req.params.id })
      .sort({ time: 1 })
      .toArray();
    res.json({ reminders: list.map(view) });
  });

  r.post('/circles/:id/reminders', async (req, res) => {
    const circleId = req.params.id;
    if (!(await isMember(circleId, req.device._id))) {
      return res.status(404).json({ error: 'not_found' });
    }
    const body = req.body || {};
    let memberIds = null;
    if (body.memberIds !== undefined && body.memberIds !== null) {
      if (!Array.isArray(body.memberIds) || body.memberIds.length > 50) {
        throw new BadRequest('memberIds');
      }
      const found = await cols.members.countDocuments({
        circleId,
        _id: { $in: body.memberIds },
      });
      if (found !== body.memberIds.length) throw new BadRequest('memberIds');
      memberIds = body.memberIds;
    }
    const now = new Date();
    const doc = {
      _id: crypto.randomUUID(),
      circleId,
      title: text(body.title, 'title', { max: 80, required: true }),
      body: text(body.body, 'body', { max: 300 }),
      memberIds,
      ...schedule(body),
      createdByDevice: req.device._id,
      createdAt: now,
      updatedAt: now,
    };
    await cols.reminders.insertOne(doc);
    res.status(201).json(view(doc));
  });

  r.patch('/reminders/:rid', async (req, res) => {
    const current = await cols.reminders.findOne({ _id: req.params.rid });
    if (!current || !(await isMember(current.circleId, req.device._id))) {
      return res.status(404).json({ error: 'not_found' });
    }
    const body = req.body || {};
    const set = { updatedAt: new Date() };
    if (body.title !== undefined) set.title = text(body.title, 'title', { max: 80, required: true });
    if (body.body !== undefined) set.body = text(body.body, 'body', { max: 300 });
    Object.assign(set, schedule(body, current));
    if (body.active === false) set.active = false;
    await cols.reminders.updateOne({ _id: current._id }, { $set: set });
    res.json(view({ ...current, ...set }));
  });

  r.delete('/reminders/:rid', async (req, res) => {
    const current = await cols.reminders.findOne({ _id: req.params.rid });
    if (!current || !(await isMember(current.circleId, req.device._id))) {
      return res.status(404).json({ error: 'not_found' });
    }
    await cols.reminders.deleteOne({ _id: current._id });
    res.json({ ok: true });
  });

  return r;
};
