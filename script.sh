#!/bin/sh
dnf update -y;
dnf install epel-release  http://rpms.remirepo.net/enterprise/remi-release-8.rpm -y;
dnf update -y;
dnf module install php:remi-7.2 -y;
dnf install tar  wget nginx php-fpm mariadb-server php-mysqli php-mbstring php-imap postfix postfix-mysql dovecot dovecot-mysql php-pear php-mcrypt php-intl php-ldap php-pear-Net-SMTP -y;

firewall-cmd --permanent --add-port=25/tcp --add-port=80/tcp --add-port=110/tcp --add-port=143/tcp --add-port=443/tcp --add-port=465/tcp --add-port=587/tcp --add-port=993/tcp --add-port=995/tcp;

firewall-cmd --reload;
setenforce 0;
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config;

wget https://sourceforge.net/projects/postfixadmin/files/latest/download -O /usr/src/postfixadmin.tar.gz;
wget https://github.com/roundcube/roundcubemail/releases/download/1.2.11/roundcubemail-1.2.11-complete.tar.gz -O /usr/src/roundcubemail.tar.gz;

systemctl enable mariadb --now

echo "hostname="
read hostname
echo "mysql_passwd="
read mysql_passwd

hostnamectl set-hostname $hostname


#mysql -u  -p -e $mysql_passwd "alter user 'root'@'localhost' identified by '$mysql_passwd';
#create database postfix;
#grant all privileges on postfix.* to 'postfix'@'localhost' identified by '$mysql_passwd';"




mysql_secure_installation <<EOF

y
$mysql_passwd
$mysql_passwd
n
n
n
n
EOF


mkdir  /usr/share/nginx/html/admin
mkdir  /usr/share/nginx/html/webmail
tar -C /usr/share/nginx/html/admin -xvf /usr/src/postfixadmin.tar.gz --strip-components=1
tar -C /usr/share/nginx/html/webmail -xvf roundcubemail-*.tar.gz --strip-components=1

mkdir /usr/share/nginx/html/admin/templates_c
chown -R apache:apache /usr/share/nginx/html/admin
<<<<<<< HEAD
chown -R apache:apache /usr/share/nginx/html/webmail
=======

>>>>>>> fabc2f92f57d14bdc4d904590e38cfe6693131ff
echo  "<?php

$CONF['configured'] = true;
$CONF['default_language'] = 'ua';
$CONF['database_password'] = '$mysql_passwd';
$CONF['emailcheck_resolve_domain']='NO';

?>" > /usr/share/nginx/html/admin/config.local.php

cp nginx.conf /etc/nginx/nginx.conf

systemctl enable nginx --now
systemctl enable php-fpm --now

groupadd -g 1024 vmail
useradd -d /home/mail -g 1024 -u 1024 vmail -m
chown vmail:vmail /home/mail
