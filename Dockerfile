FROM ubuntu:precise-20161102
LABEL maintainer=abedzilla@gmail.com

MAINTAINER abedzilla@gmail.com

ENV MAIL_HOSTNAME=localhost \
    MAIL_ADMIN=admin@localhost \
    MYSQL_DB_HOST=localhost \
    MYSQL_DB_PORT=3306 \
    MYSQL_DB_USER=root \
    MYSQL_DB_PASSWORD=secret
    

    
RUN apt-get update \
    && apt-get install -y postfix postfix-mysql dovecot-pop3d dovecot-imapd dovecot-mysql dovecot-sieve dovecot-managesieved bcrypt

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod a+x /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]
