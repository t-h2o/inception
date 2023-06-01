#!/bin/sh

ENVIRONMENT_FILE="srcs/.env"
HOSTNAME=$(cat /etc/hostname)
LOGIN="$(whoami)"
DOMAIN_NAME=${LOGIN}.42.fr

CONTAINER_NGINX="inception-container-nginx"
CONTAINER_WORDPRESS="inception-container-wordpress"
CONTAINER_MARIADB="inception-container-mariadb"

IMAGE_NGINX="inception-image-nginx"
IMAGE_WORDPRESS="inception-image-wordpress"
IMAGE_MARIADB="inception-image-mariadb"

if ! hash pwgen 2> /dev/null ; then
	printf "pwgen is not installed\n"
	exit 1
fi

if [ -f ${ENVIRONMENT_FILE} ]; then
	printf "the .env file already exist, replace it ?\n[Y/n]: "
	read answer
	if [ "${answer}" == "n" ]; then
		exit 0
	fi
fi

alias pwgen="pwgen --ambiguous --capitalize --secure 20 1"

cat > ${ENVIRONMENT_FILE} << eof
CONTAINER_NGINX=${CONTAINER_NGINX}
CONTAINER_WORDPRESS=${CONTAINER_WORDPRESS}
CONTAINER_MARIADB=${CONTAINER_MARIADB}

IMAGE_NGINX=${IMAGE_NGINX}
IMAGE_WORDPRESS=${IMAGE_WORDPRESS}
IMAGE_MARIADB=${IMAGE_MARIADB}

DOMAIN_NAME=${DOMAIN_NAME}

DATABASE_DATABASE=wordpress
DATABASE_USER_NAME=wordpress
DATABASE_USER_PASSWORD=$(pwgen)
DATABASE_ROOT_PASSWORD=$(pwgen)

HOSTNAME=${HOSTNAME}

WORDPRESS_ADMIN=${LOGIN}
WORDPRESS_MAIL=${LOGIN}@42lausanne.ch
WORDPRESS_PASSWORD=$(pwgen)
WORDPRESS_URL=https://${DOMAIN_NAME}/
eof

################################################################################

SERVER_PATH="srcs/requirements/nginx"
SERVER_KEY="${SERVER_PATH}/server.key"
SERVER_CSR="${SERVER_PATH}/server.csr"
SERVER_CRT="${SERVER_PATH}/server.crt"
EXTFILE="${SERVER_PATH}/cert_ext.cnf"

cat > ${EXTFILE} << eof
[req]
default_bit = 4096
distinguished_name = req_distinguished_name
prompt = no

[req_distinguished_name]
countryName             = CH
stateOrProvinceName     = Vaud
localityName            = Lausanne
organizationName        = 42Lausanne
commonName              = ${HOSTNAME}
eof

echo "Generating private key"
openssl genrsa -out ${SERVER_KEY} 4096

echo "Generating Certificate Signing Request"
openssl req -new -key ${SERVER_KEY} -out ${SERVER_CSR} -config ${EXTFILE}

echo "Generating self signed certificate"
openssl x509 -req -days 3650 -in ${SERVER_CSR} -signkey ${SERVER_KEY} -out ${SERVER_CRT}
