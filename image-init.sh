#!/bin/bash
set -e


## TODO:
# execute all sql/*.sql scripts in sequential order
mysql -u phpmyadmin -pDB4cc3sS -h 172.17.0.5 < /_init/sql/001-servermail.sql

cp /usr/share/postfix/main.cf.dist /etc/postfix/main.cf
## Copy all files from postfix conf
cp -fR /_init/postfix/*.cf /etc/postfix/

## Dovecot config
cp /etc/dovecot/dovecot-sql.conf.ext /etc/dovecot/dovecot-sql.conf

chown root:mail /var/mail
chmod 775 /var/mail
mkdir -p /var/mail/vhosts/abetobing.com
groupadd -g 5000 vmail
useradd -g vmail -u 5000 vmail -d /var/mail
chown -R vmail:vmail /var/mail

# copy /etc/dovecot files
pwd
cp -fR /_init/dovecot/*.ext /etc/dovecot/
cp -fR /_init/dovecot/conf.d/* /etc/dovecot/conf.d/
# change ownership
chown -R vmail:dovecot /etc/dovecot
chmod -R o-rwx /etc/dovecot

service postfix restart
service dovecot restart

#### Roundcube
mysql -u phpmyadmin -pDB4cc3sS -h 172.17.0.5 < /_init/sql/002-roundcube.sql
mkdir -p /var/www/html/roundcube
cd /var/www/html/
wget -q https://github.com/roundcube/roundcubemail/releases/download/1.3-beta/roundcubemail-1.3-beta-complete.tar.gz
tar -xzf roundcubemail-1.3-beta-complete.tar.gz
cd roundcubemail-1.3-beta
mv * /var/www/html/roundcube
cp /var/www/html/roundcube/config/config.inc.php.sample  /var/www/html/roundcube/config/config.inc.php
mysql -u phpmyadmin -pDB4cc3sS -h 172.17.0.5 roundcubedb < /var/www/html/roundcube/SQL/mysql.initial.sql

# copy config.inc.php
cd /
pwd
ls -al /_init/
cat /_init/roundcube-config.inc.php >> /var/www/html/roundcube/config/config.inc.php

service apache2 restart


exec "$@"
