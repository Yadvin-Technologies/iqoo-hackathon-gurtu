# Gurtu backend

Node + Express + MongoDB. It keeps each phone's FCM token (for push), saves
onboarding as a **care circle** with a 6-digit **family code**, lets family
join with that code, and runs a **cron job** every minute that pushes due
reminders.

## Run it

```bash
cd backend
npm install
cp .env.example .env        # then fill in MONGODB_URI (already done locally)
npm run dev                 # restarts on changes; `npm start` in production
npm test                    # time-zone unit tests + API tests on a throwaway db
```

**Push notifications** need a Firebase service account (the web config is not
enough to send): Firebase console → Project settings → Service accounts →
*Generate new private key* → save it as `backend/serviceAccountKey.json`
(git-ignored). Without it the server runs and logs skipped pushes;
`GET /health` shows `"push": false`.

**Phone → PC during development:** the app calls `http://127.0.0.1:4000`,
which reaches this PC over the USB cable once you run, for each phone:

```bash
adb -s <device-id> reverse tcp:4000 tcp:4000
```

(Redo it after a phone is unplugged.) This works on any Wi-Fi, including
networks that block phones from reaching a PC. To use a deployed server
instead: `flutter run --dart-define=GURTU_API_URL=https://your-server`.
Release builds need an https URL.

## Auth

No accounts. `POST /v1/devices` returns a token `deviceId.secret`; the app
sends it as `Authorization: Bearer <token>` on every other call. Only a hash
of the secret is stored.

## API

| Method | Path | What |
| --- | --- | --- |
| GET | `/health` | `{ ok, push }` |
| POST | `/v1/devices` | Register an install `{ fcmToken, platform, language, timezone }` → `{ deviceId, token }` |
| PUT | `/v1/devices/me` | Update token / language / time zone |
| POST | `/v1/circles` | Onboarding → circle `{ patient, patientIsMe, me: { name, role } }` |
| POST | `/v1/circles/join` | `{ code, name, role }` (rate limited: 10 tries / 15 min) |
| GET | `/v1/circles/:id` | Circle, members, who is you, who gets notifications |
| PUT | `/v1/circles/:id/patient` | Update the profile |
| POST | `/v1/circles/:id/code` | New code (owner only) |
| DELETE | `/v1/circles/:id/members/me` | Leave (ownership passes on; last one out deletes it) |
| POST | `/v1/circles/:id/notify` | Push `{ title, body }` to everyone now |
| GET/POST | `/v1/circles/:id/reminders` | List / create `{ title, body, time: "08:00", repeat: "daily" \| "once", date?, timezone?, memberIds? }` |
| PATCH/DELETE | `/v1/reminders/:id` | Change / remove |

## Reminders

Stored with their own IANA time zone (default `Asia/Kolkata`), so "08:00
daily" means 8 am where the family is. Each minute the cron claims due
reminders atomically (safe with several servers), pushes them to the
circle's phones, and schedules the next one. Anything more than 2 hours
overdue (server was down) is skipped rather than sent late. Tokens Firebase
rejects are removed.
