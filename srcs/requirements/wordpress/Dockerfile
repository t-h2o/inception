FROM alpine:3.14

RUN apk add --no-cache \
  mariadb-client \
  php7 \
  php7-phar \
  php7-fpm \
  php7-fpm \
  php7-common \
  php7-session \
  php7-iconv \
  php7-json \
  php7-gd \
  php7-curl \
  php7-xml \
  php7-mysqli \
  php7-imap \
  php7-cgi fcgi \
  php7-pdo \
  php7-pdo_mysql \
  php7-soap \
  php7-xmlrpc \
  php7-posix \
  php7-mcrypt \
  php7-gettext \
  php7-ldap \
  php7-ctype \
  php7-dom \
  php7-simplexml

RUN mkdir /wordpress

# copy the www configuration file
RUN cp /etc/php7/php-fpm.d/www.conf /etc/php7/php-fpm.d/www.conf.bk
COPY www.conf /etc/php7/php-fpm.d/www.conf

# place the entrypoint script
RUN mkdir /script
COPY entrypoint.sh /script
RUN chmod +x /script/entrypoint.sh

# launch the script when the image is launched
ENTRYPOINT ["/script/entrypoint.sh"]
