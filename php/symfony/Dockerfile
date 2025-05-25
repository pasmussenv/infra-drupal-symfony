# Imagen base PHP con FPM
FROM php:8.2-fpm

# Instalar extensiones necesarias para Symfony
RUN apt-get update && apt-get install -y \
    git unzip libicu-dev libzip-dev libonig-dev \
    && docker-php-ext-install \
    intl pdo pdo_mysql zip mbstring opcache \
    && docker-php-ext-enable opcache \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar Composer desde imagen oficial
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Establecer el directorio de trabajo
WORKDIR /var/www/html/symfony

# Copiar el contenido de la carpeta ./symfony del host al contenedor
COPY ./symfony/ .   

# Exponer el puerto del servicio FPM
EXPOSE 9000
