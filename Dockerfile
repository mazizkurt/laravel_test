FROM php:8.2-fpm

# Gerekli PHP uzantılarını kurun
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql zip

# Composer'ı indirip kurun
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Çalışma dizinini ayarlayın
WORKDIR /var/www/html

# Uygulama dosyalarını kopyalayın
COPY . /var/www/html

# Bağımlılıkları yükleyin
RUN composer install --no-interaction --no-dev --optimize-autoloader

# İzinleri ayarlayın
RUN chown -R www-data:www-data /var/www/html/storage
RUN chown -R www-data:www-data /var/www/html/bootstrap/cache
