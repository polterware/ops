# Deployment

## Overview

Ops is distributed as a Tauri desktop app. The package scripts expose web build and desktop development commands, but a complete release/signing workflow should be confirmed before public distribution.

## Build

The package script defines:

```bash
pnpm build
```

Tauri-specific packaging is available through the Tauri toolchain and project config in `src-tauri/`.

## Release Notes

- Confirm platform targets before release.
- Confirm whether builds are signed or unsigned.
- Confirm how users configure Supabase at first launch.

## Rollback

No auto-update or rollback process was confirmed in this documentation pass.
