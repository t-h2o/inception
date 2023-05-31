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

install_wp_cli () {
   wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
   chmod +x /wp-cli.phar
}

setup_wordpress () {
	/wp-cli.phar core download \
	--path="/wordpress" \
	--locale="en_US" \
	--allow-root

	/wp-cli.phar config create \
	--path="/wordpress" \
	--dbname="${DATABASE_DATABASE}" \
	--dbuser="${DATABASE_USER_NAME}" \
	--dbhost="inception-container-mariadb" \
	--dbpass="${DATABASE_USER_PASSWORD}" \
	--allow-root

	/wp-cli.phar  core install \
	--path="/wordpress" \
	--url="${DOMAIN_NAME}" \
	--title="Example" \
	--admin_user="${WORDPRESS_ADMIN}" \
	--admin_password="${WORDPRESS_PASSWORD}" \
	--admin_email="${WORDPRESS_MAIL}" \
	--allow-root
}

deamon () {
	php-fpm7 -F
}

main () {
	if [ -f "/wordpress/wp-activate.php" ]; then
		printf "WordPress is already installed\n"
	else
		printf "Download wordpress...\n"
		install_wp_cli
		setup_wordpress
		printf "Wordpress installed...\n"
	fi

	printf "launch the php-fpm deamon...\n"
	deamon
}

main
