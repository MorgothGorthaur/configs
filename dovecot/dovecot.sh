#!/bin/sh

echo "mail_location = maildir:/home/mail/%d/%u/ " >> /etc/dovecot/conf.d/10-mail.conf
echo " lda_mailbox_autocreate = yes " >>  /etc/dovecot/conf.d/15-lda.conf
cp ~/configs/dovecot/files/10-master.conf /etc/dovecot/conf.d/10-master.conf
cp ~/configs/dovecot/files/10-auth.conf /etc/dovecot/conf.d/10-auth.conf
cp ~/configs/dovecot/files/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf
cp ~/configs/dovecot/files/dovecot.conf /etc/dovecot/dovecot.conf
#echo " lda_mailbox_autocreate = yes " >>  /etc/dovecot/conf.d/15-lda.conf
echo '
driver = mysql
connect = host=localhost dbname=postfix user=postfix password=$mysql_password 
default_pass_scheme = MD5-CRYPT
password_query = SELECT password FROM mailbox WHERE username = '%u' 
user_query = SELECT maildir, 1024 AS uid, 1024 AS gid FROM mailbox WHERE username = '%u'
user_query = SELECT CONCAT('/home/mail/',LCASE(`domain`),'/',LCASE(`maildir`)), 1024 AS uid, 1024 AS gid FROM mailbox WHERE username = '%u'
'> /etc/dovecot/dovecot-sql.conf.ext
systemctl enable dovecot --now
