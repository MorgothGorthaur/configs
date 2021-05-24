









#!/bin/sh
read mysql_passwd
dnf install postfix postfix-mysql
groupadd -g 1024 vmail
useradd -d /home/mail -g 1024 -u 1024 vmail -m
chown vmail:vmail /home/mail
cp ~/main.cf /etc/postfix/main.cf
echo "
user = postfix
password = $mysql_passwd
hosts = localhost
dbname = postfix
query = SELECT goto FROM alias WHERE address='%s' AND active = '1'" >>  /etc/postfix/mysql_virtual_alias_maps.cf
echo "
user = postfix
password = $mysql_passwd
hosts = localhost
dbname = postfix
query = SELECT domain FROM domain WHERE domain='%u'" >>  /etc/postfix/mysql_virtual_domains_maps.cf
echo "
user = postfix
password = $mysql_passwd
hosts = localhost
dbname = postfix
query = SELECT CONCAT(domain,'/',maildir) FROM mailbox WHERE username='%s' AND active = '1' " >> /etc/postfix/mysql_virtual_mailbox_maps.cf
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





dnf install dovecot dovecot-mysql
cp ~/10-mail.conf  /etc/dovecot/conf.d/10-mail.conf
cp ~/10-master.conf /etc/dovecot/conf.d/10-master.conf
cp ~/10-auth.conf /etc/dovecot/conf.d/10-auth.conf
cp ~/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf
cp ~/15-lda.conf /etc/dovecot/conf.d/15-lda.conf
cp ~/auth-sql.conf.ext /etc/dovecot/conf.d/auth-sql.conf.ext
echo "
driver = mysql
connect = host=localhost dbname=postfix user=postfix password=$mysql_passwd
default_pass_scheme = MD5-CRYPT
password_query = SELECT password FROM mailbox WHERE username = '%u'
user_query = SELECT maildir, 1024 AS uid, 1024 AS gid FROM mailbox WHERE username = '%u'
user_query = SELECT CONCAT('/home/mail/',LCASE(`domain`),'/',LCASE(`maildir`)), 1024 AS uid, 1024 AS gid FROM mailbox WHERE username = '%u' " >>  /etc/dovecot/dovecot-sql.conf.ext
cp ~/dovecot.conf /etc/dovecot/dovecot.conf
systemctl enable dovecot --now
