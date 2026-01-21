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
