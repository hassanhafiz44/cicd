FROM php:8.4-cli-alpine

# Install system dependencies + build tools
RUN apk add --no-cache \
    git curl libpng-dev libjpeg-turbo-dev freetype-dev \
    oniguruma-dev libxml2-dev zip unzip linux-headers \
    autoconf make g++ gcc

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Redis extension
RUN pecl install redis \
    && docker-php-ext-enable redis

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copy composer files first (better caching)
COPY composer.json composer.lock ./

RUN composer install --no-dev --optimize-autoloader

# Copy rest of app
COPY . .

RUN chown -R www-data:www-data /var/www

EXPOSE 8000

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]