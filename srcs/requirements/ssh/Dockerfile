FROM alpine:3.14

# install package
RUN apk add --no-cache openssh

# create the work directory
RUN mkdir /documents
WORKDIR /documents

# copy the configuration file
COPY sshd_config /etc/ssh/sshd_config

# place the entrypoint script
RUN mkdir /script
COPY entrypoint.sh /script
RUN chmod +x /script/entrypoint.sh

# launch the script when the image is launched
ENTRYPOINT ["/script/entrypoint.sh"]
