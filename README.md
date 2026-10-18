# sharetripmobile
Application Project for System Analysis, Design and Development

## Support and legal content API

Run the Express backend from the repository root with `npm install` and `npm start`.
It serves the support FAQs at `/api/support/faqs` and the legal documents at
`/api/legal/terms` and `/api/legal/privacy`.

The Flutter app uses `http://localhost:3000` by default (or `10.0.2.2:3000`
on the Android emulator). Override the backend origin for another device or
environment with `--dart-define=API_BASE_URL=http://<backend-host>:3000`.
