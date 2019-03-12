#!/bin/bash
set -e

#if [ "$1" = 'postfix start' ]; then
	service postfix start
	service dovecot restart
	service apache2 restart
#fi

exec >/log/stdout.log
exec 2>/log/stderr.log

exec "$@"

