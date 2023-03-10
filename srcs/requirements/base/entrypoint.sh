#!/bin/sh

echo ${MYNAME} > file_created_by_base_image.txt

printf "\nConcatenate the configuration file into this file:\n\n" >> file_created_by_base_image.txt

cat /etc/myconfig.conf >> file_created_by_base_image.txt

printf "\nSubstitutes environment variables:\n\n" >> file_created_by_base_image.txt

envsubst < /etc/myconfig.conf >> file_created_by_base_image.txt
