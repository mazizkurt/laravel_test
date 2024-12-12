# PHP-FPM'i içeren temel imajı kullanıyoruz
FROM php:7.4-fpm

# Gerekli bağımlılıkları kuruyoruz
RUN apt-get update && apt-get install -y \
    nginx \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql zip

# Composer'ı yükleyelim
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Laravel için çalışma dizini
WORKDIR /var/www/html

# Laravel dosyalarını kopyala
COPY . /var/www/html

# Composer ile bağımlılıkları yükleyelim
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Laravel'e uygun dosya izinlerini verelim
RUN chown -R www-data:www-data /var/www/html/storage
RUN chown -R www-data:www-data /var/www/html/bootstrap/cache

# Nginx'i yapılandırma dosyasını kopyala
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./default.conf /etc/nginx/conf.d/default.conf


# Nginx ve PHP-FPM'i başlatan komutları ekleyelim
CMD service nginx start && php-fpm

# Portları expose edelim
EXPOSE 80
