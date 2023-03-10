FROM alpine:3.14

# install package
RUN apk add --no-cache gettext

# define environment variable
ENV MYNAME="my name"

# create the work directory
RUN mkdir /documents
WORKDIR /documents

# copy the configuration file
COPY conf /etc/myconfig.conf

# place the entrypoint script
RUN mkdir /script
COPY entrypoint.sh /script
RUN chmod +x /script/entrypoint.sh

# launch the script when the image is launched
ENTRYPOINT ["/script/entrypoint.sh"]
