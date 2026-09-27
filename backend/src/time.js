'use strict';

// Reminders say "08:00 every day" in the family's own time zone. These turn
// that into the exact UTC instant, with no date library.

function isValidTimeZone(tz) {
  try {
    new Intl.DateTimeFormat('en-US', { timeZone: tz });
    return typeof tz === 'string' && tz.length > 0;
  } catch {
    return false;
  }
}

/** Wall-clock parts of [date] in [tz]. */
function localParts(date, tz) {
  const parts = new Intl.DateTimeFormat('en-US', {
    timeZone: tz,
    hourCycle: 'h23',
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
  }).formatToParts(date);
  const v = Object.fromEntries(parts.map((p) => [p.type, p.value]));
  return {
    y: Number(v.year),
    m: Number(v.month),
    d: Number(v.day),
    h: Number(v.hour),
    min: Number(v.minute),
    s: Number(v.second),
  };
}

/** How far [tz] is ahead of UTC at [date], in ms. */
function offsetMs(date, tz) {
  const p = localParts(date, tz);
  const asUtc = Date.UTC(p.y, p.m - 1, p.d, p.h, p.min, p.s);
  return asUtc - Math.floor(date.getTime() / 1000) * 1000;
}

/** The instant a clock in [tz] shows y-m-d h:min. */
function zonedToUtc({ y, m, d, h, min }, tz) {
  const guess = Date.UTC(y, m - 1, d, h, min);
  const first = offsetMs(new Date(guess), tz);
  let ts = guess - first;
  // Across a daylight-saving change the offset differs: correct once.
  const second = offsetMs(new Date(ts), tz);
  if (second !== first) ts = guess - second;
  return new Date(ts);
}

function parseTime(hhmm) {
  const match = /^([01]\d|2[0-3]):([0-5]\d)$/.exec(hhmm || '');
  return match ? { h: Number(match[1]), min: Number(match[2]) } : null;
}

function parseDate(ymd) {
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(ymd || '');
  if (!match) return null;
  const [y, m, d] = match.slice(1).map(Number);
  const check = new Date(Date.UTC(y, m - 1, d));
  if (check.getUTCMonth() !== m - 1 || check.getUTCDate() !== d) return null;
  return { y, m, d };
}

/** The next time the clock in [tz] shows [hhmm], strictly after [after]. */
function nextDaily(hhmm, tz, after = new Date()) {
  const { h, min } = parseTime(hhmm);
  const today = localParts(after, tz);
  let at = zonedToUtc({ y: today.y, m: today.m, d: today.d, h, min }, tz);
  if (at <= after) {
    const tomorrow = new Date(Date.UTC(today.y, today.m - 1, today.d + 1));
    at = zonedToUtc(
      {
        y: tomorrow.getUTCFullYear(),
        m: tomorrow.getUTCMonth() + 1,
        d: tomorrow.getUTCDate(),
        h,
        min,
      },
      tz,
    );
  }
  return at;
}

module.exports = { isValidTimeZone, localParts, zonedToUtc, parseTime, parseDate, nextDaily };
