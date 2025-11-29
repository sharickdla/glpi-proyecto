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
    mariadb-client \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Extensiones PHP necesarias
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
        opcache

# Activar mod_rewrite
RUN a2enmod rewrite

# Copiar GLPI
COPY glpi/ /var/www/html/

# Permisos
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
