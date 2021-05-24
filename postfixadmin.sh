#!/bin/sh
cp ~/kurs/nginx.conf /etc/nginx/nginx.conf


mkdir /usr/share/nginx/html/postfixadmin
mkdir /usr/share/nginx/html/postfixadmin/templates_c
tar -C /usr/share/nginx/html/postfixadmin -xvf postfixadmin.tar.gz --strip-components=1
chown -R apache:apache /usr/share/nginx/html/postfixadmin



systemctl enable mariadb --now
systemctl enable php-fpm --now
systemctl enable nginx --now
echo "mysql_passwd="
read mysql_passwd
mysql_secure_installation <<EOF
y
$mysql_passwd
$mysql_passwd
n
n
n
n
EOF
mysql -p -r <<EOF
alter user 'root'@'localhost' identified by '$mysql_passwd';
create database postfix;
grant all privileges on postfix.* to 'postfix'@'localhost' identified by '$mysql_passwd';
EOF

echo "
<?php

$CONF['configured'] = true;
$CONF['default_language'] = 'ru';
$CONF['database_password'] = '$mysql_passwds';
$CONF['emailcheck_resolve_domain']='NO';

?> " > /usr/share/nginx/html/postfixadmin/config.local.php
