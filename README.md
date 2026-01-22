# AgenDAV - CalDAV web client

![GitHub stars](https://img.shields.io/github/stars/gjessing1/agendav-modern?style=social) [![License](https://img.shields.io/badge/license-gpl--3.0--or--later-blue.svg)](https://spdx.org/licenses/GPL-3.0-or-later.html) [![Latest release](https://img.shields.io/github/v/release/gjessing1/agendav-modern)](https://github.com/Gjessing1/agendav-modern/releases) [![Docker](https://img.shields.io/badge/docker-ghcr.io-blue?logo=docker)](https://github.com/Gjessing1/agendav-modern/pkgs/container/agendav-modern) [![Made With PHP](https://img.shields.io/badge/made_with-php-blue)](https://github.com/agendav/agendav#requirements) [![Contributions Welcome](https://img.shields.io/badge/contributions_welcome-brightgreen.svg)](./CONTRIBUTING.md)





AgenDAV is a CalDAV web client which features an AJAX interface to allow
users to manage their own calendars and shared ones.

![Screenshot](./docs/screenshot.png)

## About this fork

**agendav-modern** is a UI-focused fork of [AgenDAV](https://github.com/agendav/agendav).

The goal of this fork is to modernize the user interface and improve day-to-day usability while keeping the backend, database schema, and CalDAV behavior **fully compatible with upstream AgenDAV**.

**Scope**
- UI / frontend only
- No backend logic changes
- No database changes
- No API changes

This fork is intended to be a drop-in replacement for AgenDAV.

## Planned changes

> ⚠️ No changes have been implemented yet.  
> This section describes the intended direction of the project.

Planned improvements focus on visual clarity, accessibility, and modern browser expectations:

- Dark and light mode support
- Updated color palette and typography
- Improved responsiveness for smaller screens
- Minor UX refinements (spacing, contrast, visual hierarchy)
- Better accessibility defaults (contrast, focus states)

The backend behavior, CalDAV interaction, and configuration model will remain fully compatible with upstream AgenDAV.


## Requirements

AgenDAV requires:

- A CalDAV server like [Baïkal](http://baikal-server.com/),
  [DAViCal](http://www.davical.org/),
  [Radicale](https://radicale.org/tutorial/), etc
- A web server
- PHP >= 7.2.0
- PHP ctype extension
- PHP mbstring extension
- PHP mcrypt extension
- PHP cURL extension
- A database supported by
  [Doctrine DBAL](https://www.doctrine-project.org/projects/doctrine-dbal/en/2.12/reference/configuration.html#configuration)
  like MySQL, PostgreSQL, SQLite
- Optional: nodejs & npm to build assets (releases include a build)

## Documentation

https://agendav.readthedocs.io/

## Installation

See [installation guide](https://agendav.readthedocs.io/en/latest/admin/installation/)

### Docker

AgenDAV Modern provides an official Docker image published to [GitHub Container Registry (GHCR)](https://github.com/Gjessing1/agendav-modern/pkgs/container/agendav-modern).

```bash
docker pull ghcr.io/gjessing1/agendav-modern:latest
```

#### Quick Start

1. **Clone the repository and configure:**
   ```bash
   git clone https://github.com/Gjessing1/agendav-modern.git
   cd agendav-modern
   cp .env.example .env
   ```

2. **Edit `.env` with your settings** (see [Configuration](#configuration) below)

3. **Start the services:**
   ```bash
   docker compose up -d
   ```

4. **Access AgenDAV** at http://localhost:8080

#### Configuration

All configuration is done via environment variables in the `.env` file. Copy `.env.example` to `.env` and customize:

**Required settings:**
| Variable | Description | Example |
|----------|-------------|---------|
| `AGENDAV_DB_PASSWORD` | Database password | `secure_password` |
| `AGENDAV_CALDAV_BASEURL` | CalDAV server URL (`%u` = username) | `http://radicale:5232/%u` |
| `AGENDAV_ENCRYPTION_KEY` | 32-char key for password encryption | Generate with `openssl rand -base64 32` |
| `AGENDAV_CSRF_SECRET` | CSRF protection secret | Generate with `openssl rand -base64 32` |

**Common settings:**
| Variable | Description | Default |
|----------|-------------|---------|
| `AGENDAV_SITE_TITLE` | Site title shown in header | `Calendar` |
| `AGENDAV_SERVER_NAME` | Apache ServerName (for non-proxy setups) | _(empty)_ |
| `AGENDAV_TIMEZONE` | Default timezone | `UTC` |
| `AGENDAV_LANGUAGE` | Default language | `en` |
| `AGENDAV_CALDAV_AUTHMETHOD` | CalDAV auth: `basic` or `digest` | `basic` |

See [`.env.example`](./.env.example) for all available options.

#### CalDAV Server Examples

**Radicale:**
```env
AGENDAV_CALDAV_BASEURL=http://host.docker.internal:5232/%u
```

**Baïkal:**
```env
AGENDAV_CALDAV_BASEURL=http://baikal/dav.php/calendars/%u
```

**Nextcloud:**
```env
AGENDAV_CALDAV_BASEURL=https://nextcloud.example.com/remote.php/dav/calendars/%u
```

#### Reverse Proxy Setup

AgenDAV is designed to run behind a reverse proxy. The internal container exposes port 80.

**Caddy example:**
```caddyfile
http://calendar.example.com {
    reverse_proxy host.docker.internal:8080
}
```

**With Caddy + Cloudflare Tunnel:**
```caddyfile
http://calendar.example.com {
    reverse_proxy host.docker.internal:8080
}
```

**nginx example:**
```nginx
server {
    listen 80;
    server_name calendar.example.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

#### Data Persistence

The Docker Compose setup uses named volumes for data persistence:

| Volume | Purpose |
|--------|---------|
| `agendav_db` | MariaDB database files |
| `agendav_logs` | Application logs |

To back up your data:
```bash
docker compose exec db mysqldump -u root -p agendav > backup.sql
```

#### Building from Source

To build the image locally instead of pulling from GHCR:

```bash
docker compose build
docker compose up -d
```

#### Upgrading

```bash
docker compose pull
docker compose up -d
```

Database migrations run automatically on container startup when `AGENDAV_RUN_MIGRATIONS=true`.

## Source

https://github.com/agendav/agendav

## License
This project is licensed under the GNU General Public License v3.0 or later,
inherited from upstream AgenDAV.

https://spdx.org/licenses/GPL-3.0-or-later.html


## Changelog

See [CHANGELOG.md](./CHANGELOG.md)

## Upstream maintenance status

The upstream AgenDAV project is currently in maintenance mode.
This fork exists specifically to explore UI and UX improvements that are out of scope for upstream, while continuing to rely on its stable backend.

Security fixes, backend behavior, and protocol compatibility are inherited from upstream.

## Found a bug or missing a spesific feature?
- Found a bug or have an idea for an improvement? Open an issue in the repository and I’ll take a look and see if its within my capacity.

## Contribution
[Contributions](./CONTRIBUTING.md) are welcome!

## Like the project?
Please consider buying me a coffe, I really do drink it alot!
<p>
  <a href="https://buymeacoffee.com/gjessing">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" width="80" style="vertical-align: middle;">
  </a>
</p>
