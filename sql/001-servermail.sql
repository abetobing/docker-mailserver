create database servermail;
GRANT SELECT ON servermail.* TO 'mailuser'@'%' IDENTIFIED BY 'secret';
FLUSH PRIVILEGES;


use servermail;

CREATE TABLE  `virtual_domains` (
`id` int(10) NOT NULL auto_increment,
`name` varchar(40) NOT NULL,
PRIMARY KEY (`id`) )
ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `virtual_users` ( 
`id` INT NOT NULL AUTO_INCREMENT, 
`domain_id` INT NOT NULL, 
`password` varchar(106) NOT NULL, 
`email` varchar(120) NOT NULL, 
PRIMARY KEY (`id`), 
UNIQUE KEY `email` (`email`) ) 
ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `virtual_aliases` (
`id` INT NOT NULL AUTO_INCREMENT,
`domain_id` INT NOT NULL,
`source` varchar(100) NOT NULL,
`destination` varchar(100) NOT NULL,
PRIMARY KEY (`id`) )
ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `servermail`.`virtual_domains`
(`id` , `name`)
VALUES
('1', 'abetobing.com');

INSERT INTO `servermail`.`virtual_users`
(`id` , `domain_id` , `password` , `email`)
VALUES
('1', '1', MD5('mailuserpasswd'), 'postmaster@abetobing.com');

INSERT INTO `servermail`.`virtual_aliases`
(`id`, `domain_id`, `source`, `destination`)
VALUES
('1', '1', 'hi@abetobing.com', 'postmaster@abetobing.com');

