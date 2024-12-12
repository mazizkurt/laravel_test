# PHP-FPM için temel image
FROM php:8.2-fpm

# Gerekli PHP uzantılarını kurun
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

# Nginx'i yapılandırma
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./default.conf /etc/nginx/sites-available/default

# Composer'ı kurma
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Çalışma dizinini ayarlayın
WORKDIR /var/www/html

# Laravel dosyalarını kopyalayın
COPY . /var/www/html

# Laravel bağımlılıklarını yükleme
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Gerekli izinleri ayarlayın
RUN chown -R www-data:www-data /var/www/html/storage
RUN chown -R www-data:www-data /var/www/html/bootstrap/cache

# Nginx'i başlatmak için komut
CMD service nginx start && php-fpm
