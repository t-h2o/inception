#!/bin/bash

set -m

mariadbd -u mysql &

while ! mariadb-admin ping > /dev/null 2> /dev/null
do
	echo "mariadb isn't already alive; so sleep just 1 seconde..."
	sleep 1
done

if [ ! -d "/var/lib/mysql/wordpress/" ]
then

	printf "\"/var/lib/mysql/wordpress/\" does not exist"

	mariadb <<- eof
	CREATE DATABASE ${DATABASE_DATABASE};
	GRANT ALL PRIVILEGES ON ${DATABASE_DATABASE}.* TO '${DATABASE_USER_NAME}'@'${CONTAINER_WORDPRESS}.incepnet' IDENTIFIED BY '${DATABASE_USER_PASSWORD}';
	FLUSH PRIVILEGES;
	eof

else

	printf "\"/var/lib/mysql/wordpress/\" exists"

fi

fg %1
