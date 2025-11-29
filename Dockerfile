# 1. Imagen base: PHP 8.2 con Apache
FROM php:8.2-apache

# --- DEPENDENCIAS DEL SISTEMA ---

# 2. Instalar dependencias del sistema y limpiar caché de apt
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

# --- EXTENSIONES PHP ---

# 3. Configurar e instalar extensiones PHP necesarias.
#    ***IMPORTANTE: Se añaden 'mysqli' e 'intl' para corregir errores.***
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql **mysqli intl** gd xml mbstring zip opcache

# --- CONFIGURACIÓN DE APACHE ---

# 4. Activar mod_rewrite de Apache
RUN a2enmod rewrite

# --- ARCHIVOS Y PERMISOS DE GLPI ---

# 5. Copiar GLPI a /var/www/html
COPY glpi/ /var/www/html/

# 6. Establecer el propietario de los archivos al usuario de Apache (www-data)
RUN chown -R www-data:www-data /var/www/html

# 7. Asignar permisos de escritura a los directorios críticos de GLPI.
#    ***IMPORTANTE: Esto corrige los errores de "Permisos para GLPI data directories".***
RUN chmod -R 775 /var/www/html/files \
    && chmod -R 775 /var/www/html/config \
    && chmod -R 775 /var/www/html/cache \
    && chmod -R 775 /var/www/html/log \
    && chmod -R 775 /var/www/html/install \
    && chmod -R 775 /var/www/html/marketplace

# 8. Exponer el puerto
EXPOSE 80

# Comando por defecto (ya manejado por la imagen php:apache)
# CMD ["apache2-foreground"]
