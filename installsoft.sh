#! /bin/sh
dnf install chrony wget -y >> a.txt
dnf update -y >> a.txt
dnf install nginx -y >> a.txt
dnf install epel-release -y >> a.txt
dnf install http://rpms.remirepo.net/enterprise/remi-release-8.rpm -y >> a.txt
dnf module install php:remi-7.2 -y >> a.txt
dnf install php-fpm -y >> a.txt
dnf install mariadb-server -y >> a.txt
dnf install php-mysqli php-mbstring php-imap -y >> a.txt
dnf install tar -y >> a.txt
dnf install postfix postfix-mysql -y >> a.txt
dnf install php-mysqli php-mbstring php-imap -y >> a.txt
dnf install tar -y >>a.txt
dnf install dovecot dovecot-mysql -y >> a.txt
dnf install php-pear php-mcrypt php-intl php-ldap php-pear-Net-SMTP
wget wget https://sourceforge.net/projects/postfixadmin/files/latest/download -O postfixadmin.tar.gz ~/tmp
