FROM php:8.0-fpm-alpine

RUN apk add --no-cache \
        bash git curl unzip icu-dev libxml2-dev libzip-dev zlib-dev oniguruma-dev \
        autoconf gcc g++ make build-base linux-headers supervisor \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache mbstring xml \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

COPY ../../supervisor/supervisord.conf /etc/supervisord.conf

COPY ../entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
