FROM php:8.4.1-apache

# Instalar extensiones necesarias para el proyecto
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copiar archivos de tu proyecto al directorio de Apache
COPY . /var/www/html

# Establecer permisos adecuados para el directorio del proyecto
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Exponer el puerto 80
EXPOSE 80

# Iniciar Apache en primer plano
CMD ["apache2-foreground"]
