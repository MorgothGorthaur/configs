#!/bin/sh
mkdir /usr/share/nginx/html/webmail
tar -C /usr/share/nginx/html/webmail -xvf ~/tmp/roundcubemail-*.tar.gz --strip-components=1
cp /usr/share/nginx/html/webmail/config/config.inc.php.sample /usr/share/nginx/html/webmail/config/config.inc.php

cp ~/config.inc.php /usr/share/nginx/html/webmail/config/config.inc.php

chown -R apache:apache /usr/share/nginx/html/webmail

mysql -uroot -p << EOF
CREATE DATABASE roundcubemail DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON roundcubemail.* TO roundcube@localhost IDENTIFIED BY 'roundcube123'; 
EOF
mysql -uroot -p roundcubemail < /usr/share/nginx/html/webmail/SQL/mysql.initial.sql

cp ~/php.ini /etc/php.ini

systemctl restart php-fpm
systemctl restart nginx