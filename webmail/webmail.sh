#!/bin/sh
read mysql_passwd
mkdir /usr/share/nginx/html/webmail
tar -C /usr/share/nginx/html/webmail -xvf ~/tmp/roundcubemail-1.2.11-complete.tar.gz --strip-components=1
cp /usr/share/nginx/html/webmail/config/config.inc.php.sample /usr/share/nginx/html/webmail/config/config.inc.php

cp ~/configs/webmail/files/config.inc.php /usr/share/nginx/html/webmail/config/config.inc.php

chown -R apache:apache /usr/share/nginx/html/webmail

mysql -uroot -p$mysql_passwd << EOF
CREATE DATABASE roundcubemail DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON roundcubemail.* TO roundcube@localhost IDENTIFIED BY 'roundcube123'; 
EOF
mysql -uroot -p$mysql_passwd roundcubemail < /usr/share/nginx/html/webmail/SQL/mysql.initial.sql

cp ~/configs/webmail/files/php.ini /etc/php.ini

systemctl restart php-fpm
systemctl restart nginx
