#!/bin/sh

# https://wiki.alpinelinux.org/wiki/WordPress#Installing_and_configuring_WordPress

WP_CLI_PATH="/wordpress/wp-cli.phar"

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
   mv /wp-cli.phar ${WP_CLI_PATH}
   chmod +x ${WP_CLI_PATH}
}

setup_wordpress () {
	${WP_CLI_PATH} core download \
	--path="/wordpress" \
	--locale="en_US" \
	--allow-root

	${WP_CLI_PATH} config create \
	--path="/wordpress" \
	--dbname="${DATABASE_DATABASE}" \
	--dbuser="${DATABASE_USER_NAME}" \
	--dbhost="inception-container-mariadb" \
	--dbpass="${DATABASE_USER_PASSWORD}" \
	--extra-php \
	--allow-root <<- PHP
	define( 'WP_HOME', '${WORDPRESS_URL}' );
	define( 'WP_SITEURL',  '${WORDPRESS_URL}');
	PHP

	${WP_CLI_PATH}  core install \
	--path="/wordpress" \
	--url="${WORDPRESS_URL}" \
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
