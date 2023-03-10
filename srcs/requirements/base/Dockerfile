FROM alpine:3.14

# create the work directory
RUN mkdir /documents
WORKDIR /documents

# place the entrypoint script
RUN mkdir /script
COPY entrypoint.sh /script
RUN chmod +x /script/entrypoint.sh

# launch the script when the image is launched
ENTRYPOINT ["/script/entrypoint.sh"]
