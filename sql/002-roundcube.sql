create database roundcubedb;
create user roundcube;
GRANT ALL PRIVILEGES ON roundcubedb.* TO 'roundcube'@'%' IDENTIFIED BY 'roundpasswd';
FLUSH PRIVILEGES;
