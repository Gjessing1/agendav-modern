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
AgenDAV Modern does not yet have an official Docker image, but one is planned and will be published on [GitHub Container Registry (GHCR)](https://ghcr.io/) for testing and development purposes and easy deployment.

Community images built for upstream AgenDAV should also work, as backend and configuration remain fully compatible.

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
