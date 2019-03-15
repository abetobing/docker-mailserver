FROM ubuntu:bionic-20190307
LABEL maintainer=abedzilla@gmail.com

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
       mailutils rsyslog ufw vim net-tools \
       php7.2-cgi php-memcache php7.2-json php7.2-mysql php-gettext \
       php7.2-zip libapache2-mod-php7.2 php7.2-mbstring php7.2-curl libcurl4 \
    && apt install -y php-dev libmcrypt-dev php-pear \
    && pecl channel-update pecl.php.net \
    && pecl install mcrypt-1.0.1


## Genreate Self signed certificate
RUN openssl req -newkey rsa:4096 -nodes -sha512 -x509 -days 3650 -nodes -out /etc/ssl/certs/postfix.pem -keyout /etc/ssl/private/postfix.key \
     -subj "/C=ID/ST=Jakarta/L=Jakarta/O=Sedigit Inc/OU=Tech Division/CN=abetobing.com"
## Put key and cert into single file
RUN cat /etc/ssl/*/postfix.* > /etc/postfix/postfix.pem \
    && chmod 640 /etc/postfix/postfix.pem \
    && chown postfix:postfix /etc/postfix/postfix.pem


## OPTIONAL: certbot
#RUN apt-get update && apt-get install -y software-properties-common
#RUN add-apt-repository -y universe
#RUN add-apt-repository -y ppa:certbot/certbot
#RUN apt-get install -y certbot

#RUN certbot certonly --webroot -w /var/www/abetobingcom -d abetobing.com -d www.abetobing.com \
#    -w /var/www/html -d mail.abetobing.com


# Generate mail crypt key
# Private key
RUN openssl ecparam -name prime256v1 -genkey | openssl pkey -out /etc/dovecot/mailcrypt.key && chmod 0400 /etc/dovecot/mailcrypt.key
# Public key
RUN openssl pkey -in /etc/dovecot/mailcrypt.key -pubout -out /etc/dovecot/mailcrypt.pub

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

EXPOSE 25 80 110 143 465 587 993 995 4190

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["tail -f /var/log/apache2/*.log"]
