FROM php:8.4-cli-alpine

RUN apk add --no-cache \
    git curl libpng-dev libjpeg-turbo-dev freetype-dev \
    oniguruma-dev libxml2-dev zip unzip linux-headers \
    autoconf make g++ gcc

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

RUN pecl install redis \
    && docker-php-ext-enable redis

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copy composer files first (for caching)
COPY composer.json composer.lock ./

# Install dependencies WITHOUT running Laravel scripts yet
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Now copy full Laravel app (includes artisan)
COPY . .

# Now run Laravel post-install scripts
RUN php artisan package:discover

RUN chown -R www-data:www-data /var/www

EXPOSE 8000

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]