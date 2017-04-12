FROM alpine:latest
MAINTAINER Corelike (Fabian Hahn) <docker@corelike.com>

# Install packages
RUN apk --update --repository http://dl-3.alpinelinux.org/alpine/edge/main add \
  freetype-dev \
  libjpeg-turbo-dev \
  libpng-dev \
  libwebp-dev \
  php7 \
  php7-xml \
  php7-xmlreader \
  php7-xsl \
  php7-pdo_mysql \
  php7-mcrypt \
  php7-curl \
  php7-json \
  php7-fpm \
  php7-phar \
  php7-openssl \
  php7-mysqli \
  php7-ctype \
  php7-opcache \
  php7-mbstring \
  php7-zlib \
  php7-gd \
  nginx

# Small fixes and cleanup
RUN ln -s /etc/php7 /etc/php && \
  ln -s /usr/bin/php7 /usr/bin/php && \
  ln -s /usr/sbin/php-fpm7 /usr/bin/php-fpm && \
  ln -s /usr/lib/php7 /usr/lib/php && \
  rm -fr /var/cache/apk/*

# Create log files
RUN mkdir /log/nginx && \
  touch /log/nginx/access.log && \
  touch /var/log/nginx/error.log

# Mount source files TODO
COPY /src /www

# Setup nginx
RUN adduser -D -u 1000 -g 'www' www && \
  chown -R www:www /var/lib/nginx && \
  chown -R www:www /log/nginx && \
  chown -R www:www /www

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

RUN ls /etc/nginx/

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY config/php.ini /etc/php7/php.ini

# Open ports
EXPOSE 80 443

# Start nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]
