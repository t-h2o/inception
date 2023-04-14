#!/bin/sh

ENVIRONMENT_FILE="srcs/.env"

LOGIN="$(whoami)"

if [ -f ${ENVIRONMENT_FILE} ]; then
	printf "the .env file already exist, replace it ?\n[Y/n]: "
	read answer
	if [ "${answer}" == "n" ]; then
		exit 0
	fi
fi

cat > ${ENVIRONMENT_FILE} << eof
DOMAIN_NAME=${LOGIN}.42.fr

DATABASE_DATABASE=wordpress
DATABASE_USER_NAME=wordpress
DATABASE_USER_PASSWORD=$(pwgen --ambiguous --capitalize --secure 20 1)
DATABASE_ROOT_PASSWORD=$(pwgen --ambiguous --capitalize --secure 20 1)
eof
