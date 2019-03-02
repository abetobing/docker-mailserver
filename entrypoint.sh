#!/bin/bash
set -e

if [ "$1" = 'mailserver' ]; then
	postfix start

	dovecot

	while true; do
    		dovecot_pid=$(cat /var/run/dovecot/master.pid)
		if [[ ! -d "/proc/$PID" ]]; then
	    		echo "Dovecot process $dovecot_pid does not exist."
	    		break
		fi
		sleep 10
	done
fi

exec "$@"
