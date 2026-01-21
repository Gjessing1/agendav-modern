# AgenDAV Modern - Multi-stage Docker build
# Stage 1: Build assets (Node.js + PHP/Composer)
# Stage 2: Production runtime (PHP + Apache)

#############################################
# Stage 1: Builder
#############################################
FROM php:7.4-cli AS builder

# Install system dependencies for build
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    unzip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /build

# Copy package files first for better caching
COPY package.json package-lock.json* ./
COPY web/composer.json web/composer.lock* ./web/

# Install Node.js dependencies
RUN npm install

# Install PHP dependencies
WORKDIR /build/web
RUN composer install --no-dev --prefer-dist --no-interaction --optimize-autoloader
WORKDIR /build

# Copy source files needed for build
COPY assets/ ./assets/

# Create dist directories and build frontend assets
RUN mkdir -p web/public/dist/css web/public/dist/js \
    && npm run build:templates \
    && npm run build:css \
    && npm run build:js

#############################################
# Stage 2: Production runtime
#############################################
FROM php:7.4-apache

# Install PHP extensions required by AgenDAV
RUN apt-get update && apt-get install -y --no-install-recommends \
    libicu-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-install \
        ctype \
        intl \
        pdo \
        pdo_mysql \
        xml \
        zip \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite headers

# Configure Apache
ENV APACHE_DOCUMENT_ROOT=/var/www/html/web/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Add Apache configuration for AgenDAV
RUN echo '<Directory /var/www/html/web/public>\n\
    AllowOverride All\n\
    Require all granted\n\
    <IfModule mod_rewrite.c>\n\
        RewriteEngine On\n\
        RewriteCond %{REQUEST_FILENAME} !-f\n\
        RewriteRule ^ index.php [QSA,L]\n\
    </IfModule>\n\
</Directory>' > /etc/apache2/conf-available/agendav.conf \
    && a2enconf agendav

# Set working directory
WORKDIR /var/www/html

# Copy application files from builder
COPY --from=builder /build/web/vendor/ ./web/vendor/
COPY --from=builder /build/web/public/dist/ ./web/public/dist/

# Copy application source
COPY web/ ./web/
COPY agendavcli ./
COPY migrations.yml ./

# Create runtime directories
RUN mkdir -p /var/www/html/web/var/log \
    && mkdir -p /var/www/html/web/var/cache \
    && mkdir -p /var/cache/twig \
    && chown -R www-data:www-data /var/www/html/web/var \
    && chown -R www-data:www-data /var/cache/twig

# Copy entrypoint script
COPY docker/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Default environment variables
ENV AGENDAV_ENVIRONMENT=prod \
    AGENDAV_SITE_TITLE="AgenDAV" \
    AGENDAV_DB_HOST=localhost \
    AGENDAV_DB_PORT=3306 \
    AGENDAV_DB_NAME=agendav \
    AGENDAV_DB_USER=agendav \
    AGENDAV_DB_PASSWORD="" \
    AGENDAV_DB_DRIVER=pdo_mysql \
    AGENDAV_CALDAV_BASEURL="http://localhost/caldav" \
    AGENDAV_CALDAV_AUTHMETHOD=basic \
    AGENDAV_CALDAV_PUBLIC_URLS=true \
    AGENDAV_CALDAV_BASEURL_PUBLIC="" \
    AGENDAV_LOG_LEVEL=INFO \
    AGENDAV_TIMEZONE="UTC" \
    AGENDAV_LANGUAGE=en \
    AGENDAV_ENCRYPTION_KEY="" \
    AGENDAV_CSRF_SECRET=""

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
