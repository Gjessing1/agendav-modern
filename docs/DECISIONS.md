# AgenDAV Modern - Architecture Decisions

This file records architectural decisions and the reasoning behind them.

---

## 2026-01-21: Docker Build Strategy

### Decision

Use a multi-stage Docker build with PHP 7.4 and Apache as the runtime.

### Reasoning

1. **Multi-stage build**: Separates build dependencies (Node.js, npm, Composer) from runtime, resulting in smaller production images. Build tools are not needed at runtime.

2. **PHP 7.4**: The `composer.lock` file contains dependencies locked to PHP 7.x versions. While CI tests pass on PHP 8.1, the lock file would need updating to support PHP 8.x properly. PHP 7.4 was chosen for:
   - Compatibility with existing `composer.lock`
   - Stability (all dependencies tested with this version)
   - Future task: Update dependencies to support PHP 8.x

3. **Apache vs nginx**: Apache was chosen because:
   - Existing Ansible/Vagrant setup uses Apache
   - mod_rewrite configuration is well-documented for Silex
   - Simpler configuration for URL rewriting
   - PHP-FPM not required (mod_php is sufficient for this use case)

4. **Node.js 18 LTS**: Stable long-term support version for building assets.

### Alternatives considered

- **PHP 8.1**: Better performance and security, but `composer.lock` has dependencies locked to PHP 7.x. Would require running `composer update` to refresh dependencies.
- **nginx + PHP-FPM**: More performant but adds complexity. May revisit for high-traffic deployments.
- **Alpine base image**: Smaller but potential musl/glibc compatibility issues. May revisit if image size becomes a concern.

---

## 2026-01-21: Configuration via Environment Variables

### Decision

Generate `settings.php` at container startup from environment variables, rather than mounting a config file.

### Reasoning

1. **12-factor app compliance**: Configuration should come from the environment.
2. **Docker/Kubernetes friendly**: No need to manage config file volumes.
3. **Secret management**: Environment variables integrate with Docker secrets, Kubernetes secrets, etc.
4. **Sensible defaults**: Most settings have reasonable defaults; users only need to set database and CalDAV URLs.

### Alternatives considered

- **Mount settings.php volume**: More flexible but requires users to maintain a PHP config file.
- **Environment variable interpolation in PHP**: Would require modifying upstream code.

---

## 2026-01-21: GitHub Container Registry (GHCR)

### Decision

Publish Docker images to GHCR rather than Docker Hub.

### Reasoning

1. **GitHub integration**: Seamless integration with GitHub Actions and repository permissions.
2. **No rate limits**: GitHub-authenticated users have no pull rate limits.
3. **Cost**: Free for public repositories.
4. **Visibility**: Images appear on the repository's packages page.

### Alternatives considered

- **Docker Hub**: Industry standard but has rate limits for anonymous pulls.
- **Self-hosted registry**: More control but requires infrastructure management.

---

## 2026-01-21: Multi-architecture Support

### Decision

Build images for both `linux/amd64` and `linux/arm64`.

### Reasoning

1. **ARM support**: Many users run on ARM-based systems (Raspberry Pi, Apple Silicon, AWS Graviton).
2. **QEMU emulation**: GitHub Actions supports cross-architecture builds via QEMU.
3. **Minimal overhead**: Multi-arch builds add a few minutes to CI but greatly expand compatibility.

### Alternatives considered

- **amd64 only**: Simpler but excludes growing ARM user base.

---

## 2026-01-22: GHCR Build Caching Strategy

### Decision

Use GitHub Container Registry as a cache backend for Docker layer caching in CI builds, with `mode=max` to cache all layers.

### Reasoning

1. **Build performance**: Caching Docker layers significantly reduces CI build times. Multi-stage builds with npm/composer dependencies can reuse cached layers when dependencies haven't changed.

2. **GHCR as cache backend**: GitHub Container Registry provides:
   - Free storage for cache layers
   - Fast access from GitHub Actions runners
   - Automatic cleanup of old cache entries
   - No additional infrastructure required

3. **`mode=max` caching**: Caches all build stages and intermediate layers, not just the final image. This maximizes cache hits for:
   - System package installations (`apt-get install`)
   - npm dependency installation
   - Composer dependency installation
   - Asset compilation (when source hasn't changed)

4. **Cache key strategy**: Using a dedicated `:buildcache` tag ref separates cache data from production image tags, keeping the package page clean.

### Expected impact

- **First build** (cold cache): ~5-10 minutes (unchanged)
- **Subsequent builds** (warm cache, no changes): ~1-2 minutes (80-90% reduction)
- **Partial changes** (e.g., code changes but no dependency changes): ~2-4 minutes (50-70% reduction)

### Alternatives considered

- **GitHub Actions cache**: Limited to 10GB per repository, slower than registry cache for Docker layers
- **No caching (`no-cache: true`)**: Simplest but wastes CI time and resources on every build
- **`mode=min` caching**: Only caches final image layers, missing opportunities to cache build stage dependencies
