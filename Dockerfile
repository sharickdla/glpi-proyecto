FROM php:8.2-apache

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    cron \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    libonig-dev \
    mariadb-client \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Configurar e instalar extensiones PHP necesarias
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd xml mbstring zip opcache

# Activar mod_rewrite de Apache
RUN a2enmod rewrite

# Copiar GLPI a /var/www/html
COPY glpi/ /var/www/html/

# Permisos
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
