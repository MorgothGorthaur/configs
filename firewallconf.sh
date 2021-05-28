firewall-cmd --permanent --add-port=25/tcp --add-port=80/tcp --add-port=110/tcp --add-port=143/tcp --add-port=443/tcp --add-port=465/tcp --add-port=587/tcp --add-port=993/tcp --add-port=995/tcp;
firewall-cmd --reload;
