FROM php:8.4.1-apache

# Instalar extensiones necesarias para el proyecto
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Actualiza los repositorios y instala las dependencias necesarias para GD
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev

# Configura y habilita la extensión GD en PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && docker-php-ext-install gd

# Aumentar el límite de memoria de PHP a 512M
RUN echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/memory-limit.ini

# Copiar archivos de tu proyecto al directorio de Apache
COPY . /var/www/html

# Establecer permisos adecuados para el directorio del proyecto
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Exponer el puerto 80
EXPOSE 80

# Iniciar Apache en primer plano
CMD ["apache2-foreground"]
