#!/bin/sh

chown -R nginx:nginx /ssl

/usr/sbin/nginx -g 'daemon off;'
