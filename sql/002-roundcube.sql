DROP DATABASE IF EXISTS roundcubedb;
create database roundcubedb;
GRANT ALL PRIVILEGES ON roundcubedb.* TO 'roundcube'@'%' IDENTIFIED BY 'roundpasswd';
FLUSH PRIVILEGES;
