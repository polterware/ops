# Architecture

## Overview

Ops is a Tauri desktop app for business operations: catalog, inventory, orders, sales, payments, reports, roles, and analytics. The frontend is a Vite/React app, while Tauri provides the native desktop shell.

## Goals

- Provide a desktop workspace for business operations.
- Keep Supabase connection setup explicit.
- Keep privileged business data behind configured access rules.
- Support cross-platform desktop packaging through Tauri.

## System Components

### Renderer

The web UI is built with Vite and React. It owns product views, tables, dashboards, and configuration screens.

### Tauri Shell

`src-tauri/` owns the native desktop wrapper, packaging, and platform integration.

### Supabase Runtime Config

The app can use development fallback environment variables or runtime connection setup, depending on context.

## Security Model

- Development env vars must only contain publishable/default Supabase credentials.
- Privileged service-role credentials should not be embedded in the desktop client.
- Tauri permissions and local storage behavior should be reviewed before release.

## Future Improvements

- Add a release checklist for signed builds.
- Document runtime configuration storage and migration behavior.
- Add screenshots for setup, catalog, analytics, and order workflows.
