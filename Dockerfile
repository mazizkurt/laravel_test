FROM php:8.2-apache

# Gerekli PHP uzantılarını kurun
RUN docker-php-ext-install pdo pdo_mysql

# Composer'ı indirip kurun
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Apache'nin mod_rewrite modülünü etkinleştirin
RUN a2enmod rewrite

# Apache için belge kökünü /public olarak ayarlayın
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Uygulamanın dosyalarını Docker konteynerine kopyalayın
COPY . /var/www/html

# Apache konfigürasyonunu düzenleyin
RUN sed -i -e 's|/var/www/html|/var/www/html/public|' /etc/apache2/sites-available/000-default.conf
RUN sed -i -e 's|/var/www/html|/var/www/html/public|' /etc/apache2/apache2.conf

# Çalışma dizinini /var/www/html olarak ayarlayın
WORKDIR /var/www/html

# Composer ile bağımlılıkları yükleyin
RUN composer install

# Apache'yi başlatın
CMD ["apache2-foreground"]
