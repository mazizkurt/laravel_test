# PHP + Apache imajı
FROM php:8.2-apache

# Gerekli PHP uzantılarını kuruyoruz
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    nginx \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql zip

# Composer'ı kuruyoruz
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Çalışma dizinini ayarlıyoruz
WORKDIR /var/www/html

# Uygulama dosyalarını kopyala
COPY . /var/www/html

# Bağımlılıkları kuruyoruz
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Laravel için gerekli izinleri ayarlıyoruz
RUN chown -R www-data:www-data /var/www/html/storage
RUN chown -R www-data:www-data /var/www/html/bootstrap/cache

# Nginx konfigürasyonunu kopyala
COPY nginx/laravel.conf /etc/nginx/sites-available/laravel
RUN ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/

# Apache'yi başlatıyoruz
CMD service nginx start && apache2-foreground
