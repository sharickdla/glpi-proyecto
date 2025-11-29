FROM php:8.2-apache

# Instalar extensiones necesarias para GLPI
RUN apt-get update && apt-get install -y \
    cron \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    mariadb-client \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd xml mbstring zip opcache

# Activar módulos de Apache
RUN a2enmod rewrite

# Copiar GLPI a /var/www/html
COPY glpi/ /var/www/html/

# Permisos
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80