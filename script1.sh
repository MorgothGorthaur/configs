#!/bin/sh
dnf install chrony wget -y >> a.txt
systemctl enable chronyd --now
dnf update -y >> a.txt
firewall-cmd --permanent --add-port=25/tcp --add-port=80/tcp --add-port=110/tcp --add-port=143/tcp --add-port=443/tcp --add-port=465/tcp --add-port=587/tcp --add-port=993/tcp --add-port=995/tcp
firewall-cmd --reload
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
dnf install nginx -y >> a.txt


dnf install epel-release -y >> a.txt
dnf install http://rpms.remirepo.net/enterprise/remi-release-8.rpm -y >> a.txt
dnf module install php:remi-7.2 -y >> a.txt
dnf install php-fpm -y >> a.txt
cp ~/nginx.conf /etc/nginx/nginx.conf
dnf install mariadb-server -y >> a.txt
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
dnf install php-mysqli php-mbstring php-imap -y >> a.txt
dnf install tar -y >> a.txt
wget https://sourceforge.net/projects/postfixadmin/files/latest/download -O postfixadmin.tar.gz
mkdir /usr/share/nginx/html/postfixadmin
tar -C /usr/share/nginx/html/postfixadmin -xvf postfixadmin.tar.gz --strip-components=1
mkdir /usr/share/nginx/html/postfixadmin/templates_c
chown -R apache:apache /usr/share/nginx/html/postfixadmin
cp ~/config.local.php /usr/share/nginx/html/postfixadmin/config.local.php
systemctl enable php-fpm --now
systemctl enable nginx --now

dnf install postfix postfix-mysql -y >> a.txt
groupadd -g 1024 vmail
useradd -d /home/mail -g 1024 -u 1024 vmail -m
chown vmail:vmail /home/mail
cp ~/main.cf /etc/postfix/main.cf
echo "
user = postfix
password = $mysql_password
hosts = localhost
dbname = postfix
query = SELECT goto FROM alias WHERE address='%s' AND active = '1' " >> /etc/postfix/mysql_virtual_alias_maps.cf
echo "
user = postfix
password = $mysql_password
hosts = localhost
dbname = postfix
query = SELECT domain FROM domain WHERE domain='%u' " >> /etc/postfix/mysql_virtual_domains_maps.cf
echo "
user = postfix
password = $mysql_password
hosts = localhost
dbname = postfix
query = SELECT CONCAT(domain,'/',maildir) FROM mailbox WHERE username='%s' AND active = '1' " >>  /etc/postfix/mysql_virtual_mailbox_maps.cf
echo "
submission   inet  n  -  n  -  -  smtpd
  -o smtpd_tls_security_level=may
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_sasl_type=dovecot
  -o smtpd_sasl_path=/var/spool/postfix/private/auth
  -o smtpd_sasl_security_options=noanonymous
  -o smtpd_sasl_local_domain=$myhostname
smtps   inet  n  -  n  -  -  smtpd
  -o syslog_name=postfix/smtps
  -o smtpd_tls_wrappermode=yes
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_client_restrictions=permit_sasl_authenticated,reject
dovecot   unix  -  n  n  -  -  pipe
  flags=DRhu user=vmail:vmail argv=/usr/libexec/dovecot/deliver -d ${recipient} " >> /etc/postfix/master.cf
mkdir -p /etc/ssl/mail
openssl req -new -x509 -days 1461 -nodes -out /etc/ssl/mail/public.pem -keyout /etc/ssl/mail/private.key -subj "/C=UA/ST=SPb/L=SPb/O=Global Security/OU=IT Department/CN=tarasov.lnu.ua"
systemctl enable postfix --now
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


dnf install dovecot dovecot-mysql -y >> a.txt

echo "
mail_location = maildir:/home/mail/%d/%u/ " >> /etc/dovecot/conf.d/10-mail.conf

cp ~/10-master.conf /etc/dovecot/conf.d/10-master.conf

cp ~/10-auth.conf /etc/dovecot/conf.d/10-auth.conf

cp ~/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf

echo " lda_mailbox_autocreate = yes " >>  /etc/dovecot/conf.d/15-lda.conf

echo " 
driver = mysql
connect = host=localhost dbname=postfix user=postfix password=$mysql_password " >> /etc/dovecot/dovecot-sql.conf.ext
echo "
default_pass_scheme = MD5-CRYPT
password_query = SELECT password FROM mailbox WHERE username = '%u'  " >> /etc/dovecot/dovecot-sql.conf.ext

echo "
user_query = SELECT maildir, 1024 AS uid, 1024 AS gid FROM mailbox WHERE username = '%u' " >> /etc/dovecot/dovecot-sql.conf.ext
echo "user_query = SELECT CONCAT('/home/mail/',LCASE(`domain`),'/',LCASE(`maildir`)), 1024 AS uid, 1024 AS gid FROM mailbox WHERE username = '%u' " 
>> /etc/dovecot/dovecot-sql.conf.ext

cp ~/dovecot.conf /etc/dovecot/dovecot.conf

systemctl enable dovecot --now
