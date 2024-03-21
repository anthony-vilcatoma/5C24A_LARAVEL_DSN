# Usar una imagen base oficial de PHP con la versión que prefieras. 
# Esta versión incluye muchas extensiones PHP y Apache.
FROM php:8.0-apache

# Instalar dependencias del sistema para PHP y extensiones necesarias.
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libwebp-dev \
    libonig-dev \
    libxml2-dev \
    git \
    unzip \
    && apt-get clean

# Configurar y instalar extensiones de PHP utilizando docker-php-ext-configure y docker-php-ext-install
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Habilitar el mod_rewrite de Apache para las URLs amigables de Laravel
RUN a2enmod rewrite

# Instalar Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Establecer el directorio de trabajo en el directorio raíz de Apache.
WORKDIR /var/www/html

# Copiar el proyecto Laravel al contenedor
COPY . /var/www/html

# Instalar dependencias de Composer (ajustar según sea necesario para tu entorno de producción)
RUN composer install --optimize-autoloader --no-dev

# Cambiar el propietario de los archivos al usuario de Apache para evitar problemas de permisos
RUN chown -R www-data:www-data /var/www/html

# Exponer el puerto 80 para acceder al servidor web
EXPOSE 80

# El contenedor ya está configurado para arrancar con Apache en primer plano, por lo que no es necesario CMD.
