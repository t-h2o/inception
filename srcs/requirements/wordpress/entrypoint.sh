#!/bin/sh

# https://wiki.alpinelinux.org/wiki/WordPress#Installing_and_configuring_WordPress

download_wordpress () {
	cd /wordpress || exit 1
	wget http://wordpress.org/latest.tar.gz
	tar -xzvf latest.tar.gz
	rm latest.tar.gz
	mv /wordpress/wordpress/* /wordpress/
	rmdir /wordpress/wordpress
}

deamon () {
	php-fpm7 -F
}

main () {
	if [ -f "/wordpress/wp-activate.php" ]; then
		printf "WordPress is already installed\n"
	else
		printf "Download wordpress...\n"
		download_wordpress
		printf "Wordpress installed...\n"
	fi

	printf "launch the php-fpm deamon...\n"
	deamon
}

main
