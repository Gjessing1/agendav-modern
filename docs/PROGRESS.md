# AgenDAV Modern - Progress Log

This file tracks completed tasks and current project state.

---

## 2026-01-21: Docker Build Infrastructure (Task 1)

**Status**: Complete - Tested and verified working

Established Docker build infrastructure for AgenDAV Modern, enabling containerized deployment and automated publishing to GitHub Container Registry.

### What was implemented

1. **Multi-stage Dockerfile** (`Dockerfile`)
   - Build stage: PHP 7.4 CLI + Node.js 18 for asset compilation
   - Runtime stage: PHP 7.4 + Apache for production serving
   - Compiles LESS/CSS, JavaScript, and Dust.js templates
   - Installs Composer and npm dependencies
   - Configures Apache with mod_rewrite for Silex routing

2. **Docker entrypoint script** (`docker/docker-entrypoint.sh`)
   - Generates `settings.php` from environment variables
   - Configures Apache ServerName when `AGENDAV_SERVER_NAME` is set
   - Supports all AgenDAV configuration options
   - Auto-generates encryption key and CSRF secret if not provided (with warning)
   - Optional database migration on startup

3. **Environment configuration** (`.env.example`)
   - Comprehensive example with all available options
   - Documented CalDAV URL patterns for various servers
   - Security key generation instructions

4. **Docker Compose configuration** (`docker-compose.yml`)
   - AgenDAV service using `.env` file for configuration
   - MariaDB 10.11 database with health checks
   - Named volumes for data persistence
   - `host.docker.internal` support for host CalDAV servers

5. **GitHub Actions workflow** (`.github/workflows/docker.yml`)
   - Builds Docker image on push to main and on tags
   - Publishes to GHCR (ghcr.io/gjessing1/agendav-modern)
   - Multi-architecture support (amd64, arm64)
   - Build caching with GitHub Actions cache
   - Artifact attestation for supply chain security

6. **Documentation**
   - Updated README.md with comprehensive Docker instructions
   - Configuration examples for Radicale, Baikal, Nextcloud
   - Reverse proxy examples for Caddy and nginx

### Files created/modified

| File | Status |
|------|--------|
| `Dockerfile` | Created |
| `docker/docker-entrypoint.sh` | Created |
| `.dockerignore` | Created |
| `.env.example` | Created |
| `docker-compose.yml` | Created |
| `.github/workflows/docker.yml` | Created |
| `README.md` | Updated with Docker docs |
| `docs/PROGRESS.md` | Updated |
| `docs/DECISIONS.md` | Updated |

### Testing results

- Docker image builds successfully (~201MB compressed)
- Container starts and generates configuration from env vars
- Database migrations run automatically
- Login page loads correctly
- Apache routing works with mod_rewrite

### Next steps

- Push changes and verify GitHub Actions workflow
- Test with actual CalDAV server (Radicale)
- Begin UI modernization work (Task 2)

## 2024-01-21
- **Task 1 Complete:** Established Docker build system.
    - Created Dockerfile based on upstream requirements.
    - Configured GitHub Actions to build and publish to GHCR.
    - Verified container runs locally and serves the application.

---

## 2026-01-22: UI Pipeline Tracer Bullet (Task 2)

**Status**: Complete - Ready for verification

Implemented first visual change to verify the CSS/JS build pipeline works end-to-end.

### What was implemented

1. **Rounded Login Box Corners** (`assets/less/agendav.less`)
   - Added `border-radius: 12px` to `.loginform` class
   - Added subtle `box-shadow` for modern depth effect
   - Change location: lines 76-84

2. **New AgenDAV Modern Logo**
   - Added `agendav-modern-logo.png` to `web/public/img/`
   - Source: `assets/artwork/agendav-modern-transparent.png` (581x430px)
   - Updated default logo in `docker/docker-entrypoint.sh`
   - Added CSS constraints for logo sizing (max-width: 200px, max-height: 150px)

3. **Logo Container Styling** (`assets/less/agendav.less`)
   - Enhanced `div#logo` with margin and image constraints
   - Change location: lines 119-128

### Files modified

| File | Change |
|------|--------|
| `assets/less/agendav.less` | Added border-radius, box-shadow to login form; logo sizing |
| `web/public/img/agendav-modern-logo.png` | New logo file (copied from artwork) |
| `docker/docker-entrypoint.sh` | Changed default logo to agendav-modern-logo.png |

### What was NOT changed

- Backend PHP logic (as per project constraints)
- Database schema
- CalDAV protocol behavior
- Authentication logic
- Template structure (only CSS styling)

### Verification steps

1. Build Docker image: `docker-compose up --build`
2. Navigate to login page
3. Verify:
   - Login box has rounded corners (12px radius)
   - Login box has subtle shadow
   - New AgenDAV Modern logo is displayed
   - Logo is appropriately sized (max 200px wide)

### Follow-up tasks

- [ ] Optimize logo file size (currently 115KB, should be ~10-20KB)
- [ ] Consider creating multiple logo sizes for different contexts
- [ ] Verify changes appear in published GHCR image