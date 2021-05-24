#!/bin/sh
dnf install chrony wget -y
systemctl enable chronyd --now
dnf update -y
firewall-cmd --permanent --add-port=25/tcp --add-port=80/tcp --add-port=110/tcp --add-port=143/tcp --add-port=443/tcp --add-port=465/tcp --add-port=587/tcp --add-port=993/tcp --add-port=995/tcp
firewall-cmd --reload
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
dnf install nginx -y


dnf install epel-release -y
dnf install http://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
dnf module install php:remi-7.2 -y
dnf install php-fpm -y
#cp ~/nginx.conf /ext/nginx/nginx.conf
dnf install mariadb-server -y
systemctl enable mariadb --now
echo "mysql_passwd="
read mysql_passwd
hostnamectl set-hostname $hostname
mysql_secure_installation <<EOF

y
$mysql_passwd
$mysql_passwd
n
n
n
n
EOF
echo "input mysql your password "
mysql -p -r <<EOF
alter user 'root'@'localhost' identified by '$mysql_passwd';
create database postfix;
grant all privileges on postfix.* to 'postfix'@'localhost' identified by '$mysql_passwd';
EOF
dnf install php-mysqli php-mbstring php-imap -y
dnf install tar -y
wget https://sourceforge.net/projects/postfixadmin/files/latest/download -O postfixadmin.tar.gz
mkdir /usr/share/nginx/html/postfixadmin
tar -C /usr/share/nginx/html/postfixadmin -xvf postfixadmin.tar.gz --strip-components=1
mkdir /usr/share/nginx/html/postfixadmin/templates_c
chown -R apache:apache /usr/share/nginx/html/postfixadmin
#cp ~/config.local.php /usr/share/nginx/html/postfixadmin/config.local.php
systemctl enable php-fpm --now
systemctl enable nginx --now

