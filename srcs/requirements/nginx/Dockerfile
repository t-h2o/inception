FROM alpine:3.15

# install package
RUN apk add --no-cache nginx \
  gettext

# test with a local php
RUN apk add --no-cache \
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

# SSL
RUN mkdir /ssl

COPY server.crt /ssl/
COPY server.csr /ssl/
COPY server.key /ssl/

# place the entrypoint script
RUN mkdir /script
COPY entrypoint.sh /script
RUN chmod +x /script/entrypoint.sh

# copy the nginx configuration file
RUN cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bk
COPY nginx.conf /script/nginx.conf

# launch the script when the image is launched
ENTRYPOINT ["/script/entrypoint.sh"]
