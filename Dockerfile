FROM php:8.0.3-fpm-alpine

LABEL Maintainer="Alan Lam <certain603@gmail.com>" \
  Description="Lightweight container with Nginx 1.18 & PHP-FPM 8 based on Alpine Linux."

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community gnu-libiconv

ENV NGINX_VERSION 1.18.0
ENV NJS_VERSION   0.4.2
ENV PKG_RELEASE   1

# Install packages and remove default server definition
RUN set -x && \
  apk update && apk upgrade && \
  apk add --no-cache execline nginx supervisor curl tzdata htop mysql-client busybox-suid

RUN rm /etc/nginx/conf.d/default.conf

# Symlink php8 => php
RUN ln -s /usr/bin/php8 /usr/bin/php

# Install PHP tools
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY config/php.ini /etc/php8/conf.d/custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup document root
RUN mkdir -p /var/www/html

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

COPY scripts/start.sh /start.sh
RUN chmod 0755 /start.sh

# Add application
COPY src/ /var/www/html/
WORKDIR /var/www/html

# Switch to use a non-root user from here on
USER nobody

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
CMD [ "sh" , "/start.sh"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping