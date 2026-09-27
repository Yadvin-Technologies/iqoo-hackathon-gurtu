'use strict';

const test = require('node:test');
const assert = require('node:assert');
const { nextDaily, zonedToUtc, parseDate, parseTime, isValidTimeZone } = require('../src/time');
const { firstRun } = require('../src/reminders');

test('08:00 in India is 02:30 UTC', () => {
  const at = zonedToUtc({ y: 2026, m: 9, d: 27, h: 8, min: 0 }, 'Asia/Kolkata');
  assert.strictEqual(at.toISOString(), '2026-09-27T02:30:00.000Z');
});

test('the next 08:00 is today when it is still ahead, else tomorrow', () => {
  const morning = new Date('2026-09-27T01:00:00Z'); // 06:30 IST
  assert.strictEqual(
    nextDaily('08:00', 'Asia/Kolkata', morning).toISOString(),
    '2026-09-27T02:30:00.000Z',
  );
  const evening = new Date('2026-09-27T12:00:00Z'); // 17:30 IST
  assert.strictEqual(
    nextDaily('08:00', 'Asia/Kolkata', evening).toISOString(),
    '2026-09-28T02:30:00.000Z',
  );
  // Exactly at the time: the next one, not this one again.
  const exactly = new Date('2026-09-27T02:30:00Z');
  assert.strictEqual(
    nextDaily('08:00', 'Asia/Kolkata', exactly).toISOString(),
    '2026-09-28T02:30:00.000Z',
  );
});

test('month and year ends roll over', () => {
  const nye = new Date('2026-12-31T18:00:00Z'); // 23:30 IST
  assert.strictEqual(
    nextDaily('07:15', 'Asia/Kolkata', nye).toISOString(),
    '2027-01-01T01:45:00.000Z',
  );
});

test('daylight saving zones keep the wall-clock time', () => {
  // New York moves from EDT (-4) to EST (-5) on 2026-11-01.
  const before = nextDaily('09:00', 'America/New_York', new Date('2026-10-31T20:00:00Z'));
  const after = nextDaily('09:00', 'America/New_York', new Date('2026-11-01T20:00:00Z'));
  assert.strictEqual(before.toISOString(), '2026-11-01T14:00:00.000Z');
  assert.strictEqual(after.toISOString(), '2026-11-02T14:00:00.000Z');
});

test('input checks', () => {
  assert.deepStrictEqual(parseTime('21:05'), { h: 21, min: 5 });
  assert.strictEqual(parseTime('24:00'), null);
  assert.strictEqual(parseTime('8:00'), null);
  assert.deepStrictEqual(parseDate('2026-10-28'), { y: 2026, m: 10, d: 28 });
  assert.strictEqual(parseDate('2026-02-30'), null);
  assert.ok(isValidTimeZone('Asia/Kolkata'));
  assert.ok(!isValidTimeZone('Mars/Olympus'));
});

test('a one-off reminder in the past never runs', () => {
  const now = new Date('2026-09-27T10:00:00Z');
  assert.strictEqual(
    firstRun({ time: '09:00', timezone: 'Asia/Kolkata', repeat: 'once', date: '2026-09-01' }, now),
    null,
  );
  assert.strictEqual(
    firstRun(
      { time: '09:30', timezone: 'Asia/Kolkata', repeat: 'once', date: '2026-10-28' },
      now,
    ).toISOString(),
    '2026-10-28T04:00:00.000Z',
  );
});
