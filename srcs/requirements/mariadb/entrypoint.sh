#!/bin/sh

set -m # Enable Job Control

mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
mariadbd -u mysql &

sleep 1 # to be sure the deamon is launched, not the better pratice... to improve

printf "mariadbd launched\n"

if mariadb-show | grep wordpress>/dev/null ; then
	printf "wordpress database and user already installed...\n"
else
	printf "create wordpress database and user...\n"
	mariadb -u root --password='' << eof
CREATE DATABASE wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'philippe.incepnet' IDENTIFIED BY '1234';
FLUSH PRIVILEGES;
eof
	printf "wordpress database and user installed...\n"
fi

fg

# into another bash session,
# connect into the DB,
#
# apply these commands:
# CREATE DATABASE wordpress;
# GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'philippe.incepnet' IDENTIFIED BY '1234';
# FLUSH PRIVILEGES;
# EXIT
