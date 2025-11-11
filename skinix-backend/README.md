# Skinix MongoDB Backend (Express + Mongoose)

Minimal backend for Smart Foundation Mixer.

## Quick Start
1. Install Node.js (LTS) and MongoDB Atlas account.
2. Clone or unzip this project.
3. `npm install`
4. Copy `.env.example` to `.env` and set `MONGODB_URI`.
5. `npm run dev` (or `npm start`)

## API
- `POST /api/scan`
  ```json
  {
    "user_id": "saruta_01",
    "L": 72.3, "a": 5.6, "b": 18.2, "deltaE": 1.8,
    "raw": {"f1":123,"f2":234,"f3":345,"f4":456,"f5":567,"f6":678,"f7":789,"f8":801,"clear":999,"nir":850}
  }
  ```
  → `{ "success": true, "id": "<scan_id>" }`

- `POST /api/mix`
  ```json
  {
    "user_id": "saruta_01",
    "scan_id": "<id from /api/scan>",
    "formula": {"white":62,"red":18,"yellow":20,"black":0,"brown":0}
  }
  ```

- `GET /api/history/:user_id` → list of scans (newest first)
- `GET /api/history/mix/:user_id` → list of mix history

## Notes
- CORS enabled (CORS_ORIGIN in .env)
- Uses Mongoose timestamps (createdAt/updatedAt)
