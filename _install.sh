#!/bin/sh
#sh ~/configs/installsoft.sh
#sh ~/configs/firewallselinuxconfig.sh
#sh ~/configs/postfixadmin/postfixadmin.sh
#sh ~/configs/postfix/postfix.sh
#sh ~/configs/dovecot/dovecot.sh
#sh ~/configs/webmail/webmail.sha
read mysql_passwd
cd ~/root
. ./configs/installsoft.sh
. ./configs/firewallconf.sh
. ./configs/selinuxconf.sh
. ./configs/postfixadmin/postfixadmin.sh
. ./configs/postfix/postfix.sh
. ./configs/dovecot/dovecot.sh
. ./configs/webmail/webmail.sh
rm -rf ~/tmp
cd -

