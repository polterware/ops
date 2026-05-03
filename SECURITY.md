# Security Policy

## Reporting a Vulnerability

Please do not open public issues for security vulnerabilities.

Report vulnerabilities privately to:

- Email: TODO

## Supported Versions

| Version | Supported |
| ------- | --------- |
| main    | Yes       |

## Security Considerations

Ops is a desktop application that connects to Supabase and manages business data such as products, inventory, orders, sales, roles, and analytics.

Review these areas carefully:

- Supabase runtime configuration and local fallback environment variables.
- Separation between publishable keys and privileged service credentials.
- Local desktop storage of connection settings.
- Tauri permissions and file-system access.
- Install scripts and release download behavior.

## Secrets

Never commit real secrets. Use `.env.example` as a template for development-only fallback values.
