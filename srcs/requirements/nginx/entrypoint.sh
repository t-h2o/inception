#!/bin/sh

envsubst '${CONTAINER_WORDPRESS},${DOMAIN_NAME}' < /script/nginx.conf > /etc/nginx/nginx.conf

chown -R nginx:nginx /ssl

/usr/sbin/nginx -g 'daemon off;'
