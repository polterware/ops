# Getting Started

## Requirements

- Node.js.
- pnpm.
- Rust toolchain required by Tauri.
- Supabase credentials if using development fallback config.

## Installation

From `dost-ops/ops/`:

```bash
pnpm install
```

## Environment Setup

Copy `.env.example` to `.env.local` if you want development fallback values:

```bash
cp .env.example .env.local
```

The app can also use runtime configuration through the desktop UI.

## Running Locally

The package scripts define:

```bash
pnpm dev
pnpm dev:web
```

## Verification Scripts

The package scripts define:

```bash
pnpm test
pnpm lint
pnpm build
```

## Notes

- This documentation pass did not run install, dev, build, test, or lint commands.
- Keep development Supabase values out of commits.
