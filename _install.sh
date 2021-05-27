#!/bin/sh
sh ~/configs/installsoftaware.sh
sh ~/configs/firewallselinuxconfig.sh
sh ~/configs/postfixadmin/postfixadmin.sh
sh ~/configs/postfix/postfix.sh
sh ~/configs/dovecot/dovecot.sh
sh ~/configs/webmail/webmail.sh
rm -rf ~/tmp
