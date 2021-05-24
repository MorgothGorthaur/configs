#!/bin/sh
dnf install dovecot dovecot-mysql

echo "
mail_location = maildir:/home/mail/%d/%u/ " >> /etc/dovecot/conf.d/10-mail.conf

cp ~/10-master.conf /etc/dovecot/conf.d/10-master.conf

cp ~/10-auth.conf /etc/dovecot/conf.d/10-auth.conf

cp ~/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf

echo " lda_mailbox_autocreate = yes " >>  /etc/dovecot/conf.d/15-lda.conf

echo " 
driver = mysql
connect = host=localhost dbname=postfix user=postfix password=$mysql_password123
default_pass_scheme = MD5-CRYPT
password_query = SELECT password FROM mailbox WHERE username = '%u'
user_query = SELECT maildir, 1024 AS uid, 1024 AS gid FROM mailbox WHERE username = '%u'
user_query = SELECT CONCAT('/home/mail/',LCASE(`domain`),'/',LCASE(`maildir`)), 1024 AS uid, 1024 AS gid FROM mailbox WHERE username = '%u' " 
>> /etc/dovecot/dovecot-sql.conf.ext

cp ~/dovecot /etc/dovecot/dovecot.conf

systemctl enable dovecot --now
