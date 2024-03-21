# Establece la imagen base
FROM php:8.0-fpm

# Instala las dependencias de sistema necesarias
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev

# Instala las extensiones de PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd


# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Establece el directorio de trabajo
WORKDIR /var/www

# Copia la aplicación al contenedor
COPY . /var/www

# Instala las dependencias de PHP
RUN composer install --optimize-autoloader --no-dev

# Expone el puerto 8000
EXPOSE 8000

# Comando para iniciar el servidor de Laravel
CMD php artisan serve --host=0.0.0.0 --port=8000
