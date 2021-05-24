d mysql_passwd
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
