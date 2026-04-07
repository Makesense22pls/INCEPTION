FROM alpine:3.19

RUN apk update && apk add --no-cache \
    php83 php83-fpm php83-mysqli php83-mysqlnd php83-phar php83-mbstring \
    php83-tokenizer php83-ctype php83-curl php83-dom \
    php83-openssl php83-iconv php83-session \
    mariadb-client mariadb-connector-c wget bash

RUN ln -s /usr/bin/php83 /usr/bin/php

RUN if ! getent group www-data; then addgroup -S www-data; fi && \
    if ! getent passwd www-data; then adduser -S www-data -G www-data; fi

RUN sed -i "s|listen = 127.0.0.1:9000|listen = 0.0.0.0:9000|g" /etc/php83/php-fpm.d/www.conf && \
    sed -i "s|user = nobody|user = www-data|g" /etc/php83/php-fpm.d/www.conf && \
    sed -i "s|group = nobody|group = www-data|g" /etc/php83/php-fpm.d/www.conf && \
    sed -i "s|;clear_env = no|clear_env = no|g" /etc/php83/php-fpm.d/www.conf && \
    sed -i "s|display_errors = Off|display_errors = On|g" /etc/php83/php.ini && \
    sed -i "s|display_startup_errors = Off|display_startup_errors = On|g" /etc/php83/php.ini && \
    echo "extension=mysqli" > /etc/php83/conf.d/00_mysqli.ini

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    -O /usr/local/bin/wp && chmod +x /usr/local/bin/wp

WORKDIR /var/www/html

COPY tools/wp-setup.sh /usr/local/bin/wp-setup.sh

RUN chmod +x /usr/local/bin/wp-setup.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wp-setup.sh"]