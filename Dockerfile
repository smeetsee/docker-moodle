ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm-alpine AS php
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    sed -i 's/;max_input_vars = 1000/max_input_vars = 5000/g' "$PHP_INI_DIR/php.ini"
RUN apk add --no-cache icu-dev postgresql-dev
RUN docker-php-ext-install intl gd zip soap exif mysqli pgsql
COPY moodle-src /var/www/html
EXPOSE 9000

FROM nginx:alpine AS nginx
COPY nginx.conf.template /nginx.conf.template
COPY moodle-src /var/www/html
CMD ["/bin/sh" , "-c" , "envsubst '${SERVER_NAME}' < /nginx.conf.template > /etc/nginx/nginx.conf && exec nginx -g 'daemon off;'"]
EXPOSE 8080