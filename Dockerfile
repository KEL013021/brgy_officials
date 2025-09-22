# Base image: PHP + Apache
FROM php:8.2-apache

# Install required PHP extensions
RUN apt-get update && apt-get install -y \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libonig-dev \
        libzip-dev \
        unzip \
        git \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install mysqli gd zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy project files into container
COPY . /var/www/html

# Create upload folders (para sa files at pictures)
RUN mkdir -p /var/www/html/pdf_templates \
    /var/www/html/images/services \
    /var/www/html/uploads

# Fix ownership & permissions (important sa uploads)
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 /var/www/html/pdf_templates \
    && chmod -R 775 /var/www/html/images/services \
    && chmod -R 775 /var/www/html/uploads

# PHP configuration for uploads
RUN { \
        echo "file_uploads = On"; \
        echo "memory_limit = 256M"; \
        echo "upload_max_filesize = 20M"; \
        echo "post_max_size = 25M"; \
        echo "max_execution_time = 300"; \
    } > /usr/local/etc/php/conf.d/uploads.ini

# Expose Apache port
EXPOSE 80
