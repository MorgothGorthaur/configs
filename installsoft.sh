#!/bin/bash
dnf install epel-release  http://rpms.remirepo.net/enterprise/remi-release-8.rpm -y;
dnf update -y;
dnf install  chrony wget  nginx  php:remi-7.2 php-fpm mariadb-server php-mysqli php-mbstring php-imap postfix postfix-mysql  php-mysqli php-mbstring php-imap tar dovecot dovecot-mysql  php-pear php-mcrypt php-intl php-ldap php-pear-Net-SMTP -y; 
#dnf install chrony wget -y ;
#dnf update -y ;
#dnf install nginx -y ;
#dnf install epel-release -y ;
#dnf install http://rpms.remirepo.net/enterprise/remi-release-8.rpm -y ;
#dnf module install php:remi-7.2 -y ;
#dnf install php-fpm -y  ;
#dnf install mariadb-server -y ;
#dnf install php-mysqli php-mbstring php-imap -y ;
#dnf install tar -y ;
#dnf install postfix postfix-mysql -y ;
#dnf install php-mysqli php-mbstring php-imap -y ;
#dnf install tar -y ;
#dnf install dovecot dovecot-mysql -y;
#dnf install php-pear php-mcrypt php-intl php-ldap php-pear-Net-SMTP -y ;
mkdir ~/tmp;
wget https://sourceforge.net/projects/postfixadmin/files/latest/download -O ~/tmp/postfixadmin.tar.gz ;
wget https://github.com/roundcube/roundcubemail/releases/download/1.2.11/roundcubemail-1.2.11-complete.tar.gz -O ~/tmp/roundcubemail
.tar.gz;
