FROM alpine:3.14

# install package
RUN apk add --no-cache nginx

RUN mkdir /wordpress

# place the entrypoint script
RUN mkdir /script
COPY entrypoint.sh /script
RUN chmod +x /script/entrypoint.sh

# launch the script when the image is launched
ENTRYPOINT ["/script/entrypoint.sh"]
