#!/bin/bash
set -e

if [ "$1" = 'postfix start' ]; then
	postfix start
	service dovecot restart
	service apache2 restart
fi

exec "$@"

