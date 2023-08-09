FROM alpine:3.15

# install package
RUN apk add --no-cache nginx \
  gettext

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
