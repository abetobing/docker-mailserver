FROM ubuntu:xenial-20190122
LABEL maintainer=abedzilla@gmail.com

MAINTAINER abedzilla@gmail.com

ENV MAIL_HOSTNAME=localhost \
    MAIL_ADMIN=admin@localhost \
    MYSQL_DB_HOST=localhost \
    MYSQL_DB_PORT=3306 \
    MYSQL_DB_USER=root \
    MYSQL_DB_PASSWORD=secret 
    
SHELL ["/bin/bash", "-c"]
    
RUN apt-get update \
    && debconf-set-selections <<< "postfix postfix/mailname string mail.abetobing.com" \
    && debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'" \
    && apt-get install -y wget postfix postfix-mysql dovecot-core dovecot-imapd dovecot-pop3d dovecot-lmtpd dovecot-mysql mysql-client \
       php7.0-cgi php7.0-mcrypt php-memcache php7.0-json php7.0-mysql php-gettext libapache2-mod-php7.0 php7.0-mbstring php7.0-curl libcurl3 libcurl3-dev

## Vimbadmin

COPY entrypoint.sh /sbin/entrypoint.sh
COPY init.sh /_init/init.sh
RUN mkdir -p /_init/sql /_init/postfix /_init/dovecot/conf.d
ADD sql/* /_init/sql/
ADD etc/postfix/*.cf /_init/postfix/
ADD etc/dovecot/*.ext /_init/dovecot/
ADD etc/dovecot/conf.d/* /_init/dovecot/conf.d/
ADD roundcube-config.inc.php /_init/roundcube-config.inc.php

RUN chmod a+x /sbin/entrypoint.sh /_init/init.sh
RUN sh /_init/init.sh

EXPOSE 25 80 110 143 4190

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["tail -f /var/log/apache2/*.log"]
