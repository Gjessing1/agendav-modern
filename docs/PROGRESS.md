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

---

## 2026-01-22: General UI Enhancements (Task 3)

**Status**: Complete - Ready for verification

Implemented general UI enhancements focusing on login page refinements, calendar navbar improvements, and CI build caching.

### What was implemented

1. **GitHub Container Registry (GHCR) Caching** (`.github/workflows/docker.yml`)
   - Removed `no-cache: true` to enable build caching
   - Added `cache-from` parameter pointing to GHCR buildcache ref
   - Added `cache-to` parameter with `mode=max` for comprehensive layer caching
   - Expected impact: Significantly faster CI builds by reusing Docker layers
   - Change location: lines 62-63

2. **Login Page Enhancements** (`assets/less/agendav.less`)
   - **Increased border radius**: 12px → 18px for more modern appearance (line 82)
   - **Added visual separation**: Increased top margin from 0 → 40px on logo container (line 141)
   - **Reduced logo size**: Container 300px → 240px (-20%), max-height 150px → 120px (-20%) (lines 140-145)

3. **Calendar Navbar Logo Repositioning**
   - **Template changes** (`web/templates/parts/navbar.html`):
     - Added logo inside navbar-header before the title (lines 4-7)
   - **Template changes** (`web/templates/parts/sidebar.html`):
     - Removed logo from sidebar (previously lines 1-5)
   - **CSS changes** (`assets/less/agendav.less`):
     - Added `#navbar-logo` styles with 40px max-height aligned with navbar
     - Added flexbox display to `.navbar-header` for proper alignment
     - Replaced sidebar logo styles with navbar logo styles (lines 150-163, 165-167)

### Files modified

| File | Change |
|------|--------|
| `.github/workflows/docker.yml` | Enabled GHCR caching with cache-from/cache-to |
| `assets/less/agendav.less` | Login form radius, logo sizing, navbar logo styles |
| `web/templates/parts/navbar.html` | Added logo before title in navbar-header |
| `web/templates/parts/sidebar.html` | Removed logo from sidebar |

### What was NOT changed

- Backend PHP logic (as per project constraints)
- Database schema
- CalDAV protocol behavior
- Authentication logic
- Build architecture or dependencies
- CSS architecture (targeted changes only, no large refactoring)

### Verification steps

1. Build Docker image: `docker-compose up --build`
2. Verify login page:
   - Login box has more rounded corners (18px radius vs 12px)
   - More spacing above logo (40px top margin)
   - Logo is smaller (240px container vs 300px)
3. Log in and verify calendar page:
   - Logo appears in navbar, left of the heading
   - Logo is sized appropriately (~40px height, aligned with navbar text)
   - Logo no longer appears in sidebar

### Expected benefits

- **Build performance**: GHCR caching should reduce CI build times from ~5-10 minutes to ~1-2 minutes for unchanged layers
- **Visual polish**: More modern, rounded login form with better spacing
- **Improved layout**: Logo in navbar provides better brand visibility and cleaner sidebar

---

## 2026-01-23: Token-Based Architecture Refactor (Task 4)

**Status**: Complete - Verified with build

Transitioned the custom application styles to a token-based architecture using CSS Variables. This lays the foundation for future theming (e.g., Dark Mode) while maintaining strict visual parity with the existing design.

### What was implemented

1.  **Token System** (`assets/css/variables.css`)
    -   Created a new CSS file defining the color palette.
    -   Defined **Primitive Tokens**: Raw hex values (e.g., `--color-white`, `--color-gray-100`).
    -   Defined **Semantic Tokens**: Mapped primitives to usage (e.g., `--bg-surface-primary`, `--text-secondary`).
    -   Followed naming convention: `--bg-*`, `--text-*`, `--border-*`.

2.  **Styles Refactoring** (`assets/less/agendav.less`)
    -   Replaced all hardcoded hex/rgb color values with `var(--token-name)`.
    -   Ensured no orphan hex codes remain in the custom app styles.
    -   Mapped specific elements like `.loginform`, `#footer`, `.share_info`, `.fc-today` to appropriate semantic tokens.

3.  **Bootstrap Variable Overrides** (`assets/less/bootstrap_variables.less`)
    -   Updated `@agendavbgColor` and `@agendavbgHoverPseudobutton` to use the new CSS variables.

4.  **Build Verification**
    -   Verified that `npm run build:css` includes the new `variables.css` (concatenated into `agendav.css`) and compiles successfully.
    -   Ran `npm install` to ensure environment readiness.

### Files created/modified

| File | Change |
|------|--------|
| `assets/css/variables.css` | Created: Defines CSS variables (primitives and semantics) |
| `assets/less/agendav.less` | Modified: Replaced hardcoded colors with `var(--...)` |
| `assets/less/bootstrap_variables.less` | Modified: Updated custom variables to use tokens |
| `docs/PROGRESS.md` | Updated |

### What was NOT changed

-   `assets/less/bootstrap.theme.less` and other vendor files were left largely untouched to avoid breaking complex Less mixins (darken/lighten) and to minimize risk, adhering to the "Safe Refactor" scope.
-   Visual design (layout, spacing, fonts) remains identical.

### Verification steps

1.  Run `npm install && npm run build:css`.
2.  Inspect `web/public/dist/css/agendav.css` (if accessible) or load the app.
3.  Verify that `var(--...)` references are present and the app looks unchanged.