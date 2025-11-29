FROM php:8.2-apache

# Dependencias del sistema
RUN apt-get update && apt-get install -y \
    cron \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    libonig-dev \
    libicu-dev \
    libsodium-dev \
    libldap2-dev \
    libbz2-dev \
    mariadb-client \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Extensiones PHP necesarias por GLPI
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        pdo \
        pdo_mysql \
        mysqli \
        intl \
        gd \
        xml \
        mbstring \
        zip \
        opcache \
        exif \
        ldap \
        bcmath \
        bz2 \
        sodium

# Activar mod_rewrite
RUN a2enmod rewrite

# Copiar GLPI
COPY glpi/ /var/www/html/

# Crear todas las carpetas de GLPI
RUN mkdir -p /var/www/html/files/_cache \
    /var/www/html/files/_cron \
    /var/www/html/files/_dumps \
    /var/www/html/files/_graphs \
    /var/www/html/files/_lock \
    /var/www/html/files/_pictures \
    /var/www/html/files/_plugins \
    /var/www/html/files/_rss \
    /var/www/html/files/_sessions \
    /var/www/html/files/_tmp \
    /var/www/html/files/_uploads \
    /var/www/html/marketplace

# Permisos correctos
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/files \
    && chmod -R 775 /var/www/html/config \
    && chmod -R 775 /var/www/html/marketplace

EXPOSE 80
