FROM alpine:3.17

RUN apk update

RUN apk add --no-cache bash mariadb mariadb-client

RUN mkdir /var/run/mysqld; \
    chown mysql:mysql /var/run/mysqld;

RUN sed -i 's/#bind-address=0.0.0.0/ bind-address=0.0.0.0/' /etc/my.cnf.d/mariadb-server.cnf
RUN sed -i 's/skip-networking/skip-networking=0/' /etc/my.cnf.d/mariadb-server.cnf

RUN mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# place the entrypoint script
RUN mkdir /script
COPY entrypoint.sh /script/
RUN chmod +x /script/entrypoint.sh

# launch a shell
ENTRYPOINT ["bash", "/script/entrypoint.sh"]
