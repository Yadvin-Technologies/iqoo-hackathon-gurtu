'use strict';

const cron = require('node-cron');
const { nextDaily, parseDate, parseTime, zonedToUtc } = require('./time');
const { circleDevices, sendToDevices } = require('./push');

/** A reminder due longer ago than this (server was down) is skipped. */
const STALE_MS = 2 * 60 * 60 * 1000;

/** When a reminder should next go out, or null when it never will again. */
function firstRun({ time, timezone, repeat, date }, now = new Date()) {
  if (repeat === 'daily') return nextDaily(time, timezone, now);
  const { h, min } = parseTime(time);
  const day = parseDate(date);
  const at = day ? zonedToUtc({ ...day, h, min }, timezone) : nextDaily(time, timezone, now);
  return at > now ? at : null;
}

/**
 * Sends every reminder that is due. Each one is claimed by moving its
 * nextRunAt on before sending, so two servers (or two overlapping ticks)
 * never send the same reminder twice.
 */
async function runDueReminders(cols, now = new Date()) {
  const due = await cols.reminders
    .find({ active: true, nextRunAt: { $lte: now } })
    .sort({ nextRunAt: 1 })
    .limit(200)
    .toArray();
  let sent = 0;
  for (const r of due) {
    const next = r.repeat === 'daily' ? nextDaily(r.time, r.timezone, now) : null;
    const claimed = await cols.reminders.updateOne(
      { _id: r._id, nextRunAt: r.nextRunAt, active: true },
      {
        $set: {
          nextRunAt: next,
          active: next !== null,
          lastRunAt: now,
          updatedAt: now,
        },
      },
    );
    if (claimed.modifiedCount !== 1) continue;
    if (now - r.nextRunAt > STALE_MS) {
      await cols.reminders.updateOne({ _id: r._id }, { $set: { lastResult: 'skipped_stale' } });
      continue;
    }
    try {
      const devices = await circleDevices(cols, r.circleId, { memberIds: r.memberIds });
      const result = await sendToDevices(cols, devices, {
        title: r.title,
        body: r.body,
        data: { type: 'reminder', reminderId: r._id, circleId: r.circleId },
      });
      sent += result.sent;
      await cols.reminders.updateOne({ _id: r._id }, { $set: { lastResult: result } });
    } catch (e) {
      console.error(`[reminders] ${r._id} failed:`, e.message);
      await cols.reminders.updateOne(
        { _id: r._id },
        { $set: { lastResult: { error: e.message } } },
      );
    }
  }
  return { due: due.length, sent };
}

/** Checks for due reminders at the start of every minute. */
function startReminderCron(cols) {
  let running = false;
  const task = cron.schedule('* * * * *', async () => {
    if (running) return; // The previous tick is still sending.
    running = true;
    try {
      const { due, sent } = await runDueReminders(cols);
      if (due) console.log(`[reminders] ${due} due, ${sent} notification(s) sent`);
    } catch (e) {
      console.error('[reminders] tick failed:', e.message);
    } finally {
      running = false;
    }
  });
  return task;
}

module.exports = { firstRun, runDueReminders, startReminderCron };
