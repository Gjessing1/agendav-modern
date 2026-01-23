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

---

## 2026-01-23: Login Page & Mobile Responsiveness (Task 5)

**Status**: Complete - Verified with build

Improved the responsiveness of the login page and analyzed the codebase for future "Mobile First" improvements.

### What was implemented

1.  **Responsive Login Form** (`assets/less/agendav.less`)
    -   Changed `.loginform` width from fixed `430px` to `max-width: 430px; width: 90%;`.
    -   Changed `.loginerrors` width from fixed `400px` to `max-width: 400px; width: 90%;`.
    -   This ensures the form scales down gracefully on mobile devices while maintaining the original design on desktop.

2.  **Cleaner Template** (`web/templates/login.html`)
    -   Removed `ui-corner-all` class from `.loginform` to prevent potential conflicts with the custom `border-radius` (18px) and separate legacy jQuery UI styles from modern app styles.

### Mobile First Audit (Future Work)

A review of the codebase identified several areas for improvement to achieve a true "Mobile First" experience:

1.  **Sidebar (`#sidebar`)**: Currently fixed `max-width: 200px`. On mobile, this should likely be a collapsible drawer or off-canvas menu.
2.  **Event Details (`.view_event_details`)**: Has `width: 400px !important`. This will break on small screens. Needs to be converted to a full-screen modal or a responsive bottom sheet on mobile.
3.  **Share Info (`div.share_info`)**: Fixed width `350px`. Needs responsive `max-width`.
4.  **jQuery UI Dialogs**: Many dialogs rely on jQuery UI's absolute positioning and calculated widths. These often fail on mobile. Replacing them with Bootstrap Modals (already available in the project) would be a significant upgrade.
5.  **Tables**: `#calendar_share_table`, `#reminders_table`, and calendar views need a strategy for narrow screens (e.g., horizontal scroll, stacked cards, or simplified views).
6.  **FullCalendar**: Verify `fc-view` behavior on mobile. "List" view is often better than "Month" view for small devices.

### Files modified

| File | Change |
|------|--------|
| `assets/less/agendav.less` | Responsive widths for login form/errors |
| `web/templates/login.html` | Removed `ui-corner-all` class |
| `docs/PROGRESS.md` | Updated |

### Verification steps

1.  Build CSS: `npm run build:css`
2.  Open Login page.
3.  Resize browser window < 430px.
4.  Verify form shrinks to fit (90% width) and margins remain consistent.

---

## 2026-01-23: Mobile-First CSS Architecture (Task 6)

**Status**: Complete - Verified with build

Implemented mobile-first CSS patterns to replace fixed widths with responsive layouts. All critical components now scale from mobile (100% width) to desktop (constrained widths) using media queries at 768px breakpoint.

### What was implemented

1.  **Event Details Popup** (`.view_event_details`)
    -   Changed from: `width: 400px !important; max-width: 400px !important;`
    -   Changed to: `width: 90%; max-width: 400px;`
    -   Removed dangerous `!important` flags that prevented responsive behavior
    -   Location: `assets/less/agendav.less:234-235`

2.  **Share Info Box** (`div.share_info`)
    -   Changed from: `width: 350px;`
    -   Changed to: `width: 90%; max-width: 350px;`
    -   Location: `assets/less/agendav.less:310`

3.  **Sidebar & Content Layout** (`#sidebar` and `#content`)
    -   **Mobile (< 768px)**: Stack vertically at 100% width
    -   **Tablet+ (≥ 768px)**: Side-by-side 2/10 column layout with 200px max-width sidebar
    -   Added first `@media (min-width: @screen-sm-min)` breakpoint to app styles
    -   Location: `assets/less/agendav.less:102-121`

4.  **Responsive Table Wrapper** (`.table-responsive`)
    -   Added utility class with horizontal scroll on mobile
    -   Automatically disables overflow on desktop (≥ 768px)
    -   Ready for use in templates
    -   Location: `assets/less/agendav.less:418-427`

### Files modified

| File | Change |
|------|--------|
| `assets/less/agendav.less` | Added mobile-first patterns, media queries, responsive widths |
| `docs/PROGRESS.md` | Updated with Task 6 completion |

### What was NOT changed

-   No JavaScript modifications (CSS-only changes per mobile-first constraints)
-   No template files modified (styles ready, templates can be updated separately)
-   No backend PHP logic touched
-   Bootstrap core files untouched
-   Build configuration unchanged

### Verification steps

1.  Build CSS: `npm run build:css`
2.  Test event detail popups on mobile viewports (≤ 375px width)
3.  Verify sidebar/content stacking on tablet breakpoint (768px)
4.  Check share info dialogs on small screens (< 350px)
5.  Resize browser to confirm smooth responsive behavior

### Potential follow-ups

-   [x] Apply `.table-responsive` wrapper to actual table elements in templates (✅ Completed in Task 6.1)
-   [x] Test and optimize FullCalendar mobile responsiveness (✅ Completed in Task 6.2)
-   [x] Consider collapsible/off-canvas sidebar for better mobile UX (✅ Completed in Task 6.2)
-   [ ] Replace jQuery UI dialogs with mobile-friendly alternatives (long-term improvement)

---

## 2026-01-23: Mobile UX Enhancements - Tables, Sidebar & Calendar (Task 6 Follow-ups)

**Status**: Complete - Verified with build

Implemented three major mobile UX improvements as follow-ups to Task 6's mobile-first foundation.

### What was implemented

#### 1. Responsive Table Wrappers

**Templates Modified:**
-   `assets/templates/calendar_share_table.dust` - Wrapped `#shares` div
-   `assets/templates/reminders.dust` - Wrapped `#reminders` div

**Result:**
-   Tabular layouts now scroll horizontally on mobile (<768px) instead of breaking layout
-   Smooth touch scrolling enabled with `-webkit-overflow-scrolling: touch`
-   Tables remain normal on desktop (≥768px)

#### 2. Off-Canvas Sidebar Navigation

**Templates:**
-   Added hamburger button (`#sidebar-toggle`) to navbar with three horizontal bars
-   Added overlay div (`#sidebar-overlay`) to darken content when sidebar is open
-   Location: `web/templates/parts/navbar.html`, `web/templates/calendar.html`

**CSS (`assets/less/agendav.less`):**
-   Mobile (<768px): Sidebar positioned fixed, off-screen at `left: -250px`
-   Slides in via `transform: translateX(250px)` when `.sidebar-open` class is applied to body
-   Hamburger button styled with 44px min-height (iOS recommended touch target)
-   Semi-transparent overlay (rgba(0,0,0,0.5)) appears behind sidebar
-   Desktop (≥768px): Hamburger hidden, sidebar returns to static position

**JavaScript (`assets/js/app/app.js`):**
-   Toggle `.sidebar-open` class on hamburger click
-   Remove class when overlay is clicked (closes sidebar)
-   Auto-close sidebar when sidebar link is clicked on mobile
-   Uses jQuery event handlers for compatibility

**Result:**
-   Mobile users can access sidebar via hamburger menu
-   Desktop users see unchanged side-by-side layout
-   Smooth 0.3s transition animations

#### 3. FullCalendar Mobile Optimizations

**CSS (`assets/less/agendav.less`):**
-   Larger touch targets for calendar buttons: 44px min-height (iOS guideline)
-   Increased button padding: 8px 12px
-   Improved header toolbar spacing: 10px 5px with 5px margins on sections
-   Larger event text: 13px with 4px 6px padding
-   Hidden week numbers on mobile to save horizontal space
-   Larger day numbers: 14px font-size with 8px padding
-   Better list item spacing: 10px padding
-   Improved "more events" link: 13px font-size, 4px padding

**JavaScript (`assets/js/app/app.js`):**
-   Auto-switch to list view when screen width < 768px
-   Only applies to users with month/week default views
-   Day and list view users keep their preferences
-   Desktop users (≥768px) always see their preferred view
-   Detection runs once at page load

**Result:**
-   Calendar buttons are easier to tap on mobile
-   List view provides better mobile experience than cramped month view
-   Touch interactions more reliable with larger targets
-   User preferences respected on desktop

### Files modified

| File | Change |
|------|--------|
| `assets/templates/calendar_share_table.dust` | Added .table-responsive wrapper |
| `assets/templates/reminders.dust` | Added .table-responsive wrapper |
| `assets/templates/templates.js` | Rebuilt Dust templates |
| `web/templates/parts/navbar.html` | Added hamburger button |
| `web/templates/calendar.html` | Added sidebar overlay div |
| `assets/less/agendav.less` | Added sidebar + FullCalendar mobile styles |
| `assets/js/app/app.js` | Added sidebar toggle + list view mobile default |
| `docs/PROGRESS.md` | Updated with Task 6 follow-ups |

### What was NOT changed

-   jQuery UI dialogs remain unchanged (per user request - future work)
-   No backend PHP logic modified
-   Database schema unchanged
-   CalDAV protocol behavior unchanged
-   Desktop experience preserved (all changes are mobile-only)
-   User preferences still respected (mobile list view is smart default, not forced)

### Verification steps

1.  Build assets: `npm run build:css && npm run build:js && npm run build:templates`
2.  **Test Sidebar:**
    -   Resize browser < 768px
    -   Verify hamburger appears in navbar
    -   Click hamburger, sidebar slides in from left
    -   Click overlay or sidebar link, sidebar closes
    -   Resize > 768px, verify sidebar is static and hamburger hidden
3.  **Test Tables:**
    -   Navigate to calendar sharing or reminders
    -   On mobile viewport, verify horizontal scroll if content overflows
    -   On desktop, verify normal table display
4.  **Test Calendar:**
    -   Open calendar on mobile viewport (<768px)
    -   Verify list view loads by default (if user pref was month/week)
    -   Check button sizes (should be easy to tap)
    -   Verify event text is readable
    -   Resize to desktop, verify normal calendar view

### Remaining follow-ups

-   [ ] Replace jQuery UI dialogs with mobile-friendly alternatives (future enhancement)
-   [ ] Consider progressive web app (PWA) features (installability, offline support)
-   [ ] Test with real CalDAV server and production data
-   [ ] Gather user feedback on mobile experience