#!/bin/sh
mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
mariadbd -u mysql

# into another bash session,
# connect into the DB,
# apply this command
# GRANT ALL on root.* to root@_gateway IDENTIFIED BY '1234';
# this command enable the root user
# to connect into the docker image from the docker host
# _gateway is an alias as localhost
