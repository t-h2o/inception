#!/bin/sh

ENVIRONMENT_FILE="srcs/.env"

LOGIN="$(whoami)"

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
DOMAIN_NAME=${LOGIN}.42.fr

DATABASE_DATABASE=wordpress
DATABASE_USER_NAME=wordpress
DATABASE_USER_PASSWORD=$(pwgen)
DATABASE_ROOT_PASSWORD=$(pwgen)
eof
