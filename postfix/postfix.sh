read mysql_password
groupadd -g 1024 vmail
useradd -d /home/mail -g 1024 -u 1024 vmail -m
chown vmail:vmail /home/mail
mkdir -p /etc/ssl/mail
openssl req -new -x509 -days 1461 -nodes -out /etc/ssl/mail/public.pem -keyout /etc/ssl/mail/private.key -subj "/C=UA/ST=SPb/L=SPb/O=Global Security/OU=IT Department/CN=tarasov.lnu.ua"


cp ~/configs/postfix/files/main.cf /etc/postfix/main.cf
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



systemctl enable postfix --now
