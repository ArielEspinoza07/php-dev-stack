FROM php:5.6-fpm-alpine

RUN apk add --no-cache \
        bash git curl unzip icu-dev libxml2-dev libzip-dev zlib-dev oniguruma-dev \
        supervisor \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache mbstring xml

WORKDIR /var/www/html

COPY docker/supervisor/supervisord.conf /etc/supervisord.conf

COPY docker/php/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
