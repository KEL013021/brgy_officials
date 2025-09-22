# Gumamit ng official PHP + Apache image
FROM php:8.2-apache

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install mysqli (since ginagamit mo MySQLi, hindi PDO)
RUN docker-php-ext-install mysqli

# Copy project files
COPY . /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Set proper permissions para sa uploads
RUN mkdir -p /var/www/html/pdf_templates \
    && chown -R www-data:www-data /var/www/html/pdf_templates \
    && chmod -R 775 /var/www/html/pdf_templates
