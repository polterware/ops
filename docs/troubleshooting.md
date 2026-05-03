# Troubleshooting

## Supabase is not configured

Symptoms:

- The app shows connection/setup errors.
- Data surfaces remain empty.

Checks:

- Configure the connection in the app UI, or provide development fallback variables in `.env.local`.
- Confirm `VITE_SUPABASE_URL`.
- Confirm `VITE_SUPABASE_PUBLISHABLE_DEFAULT_KEY`.

## Tauri development does not start

Checks:

- Confirm Rust and Tauri prerequisites are installed.
- Confirm Node dependencies are installed.
- Use `pnpm dev:web` to isolate renderer issues when needed.

## Tests or lint fail

Checks:

- `pnpm test` uses Vitest.
- `pnpm lint` uses ESLint.
- `pnpm check` writes formatting and applies eslint fixes, so review diffs after using it.
