#!/bin/bash -xe

#The database values in this file must match your wp-config.local.php file.

#See /var/log/cloud-init.log for troubleshooting.
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

#declare db secrets
#make sure escaped chars are not a problem
echo export ROOTSQLPASS=<your_root_password> >> ~/.bashrc
echo export DB_NAME=<your_db_name> >> ~/.bashrc
echo export DB_USER=<your_db_username> >> ~/.bashrc
echo export DB_PASSWORD=<your_db_password> >> ~/.bashrc
echo export AUTH_KEY=<your_auth_key> >> ~/.bashrc
echo export SECURE_AUTH_KEY=<your_secure_auth_key> >> ~/.bashrc
echo export LOGGED_IN_KEY=<your_logged_in_key> >> ~/.bashrc
echo export NONCE_KEY=<your_nonce_key> >> ~/.bashrc
echo export AUTH_SALT=<your_auth_salt> >> ~/.bashrc 
echo export SECURE_AUTH_SALT=<your_secure_auth_salt> >> ~/.bashrc
echo export LOGGED_IN_SALT=<your_logged_in_salt> >> ~/.bashrc
echo export NONCE_SALT=<your_nonce_salt> >> ~/.bashrc


#see http://stackoverflow.com/questions/4870253/sed-replace-single-double-quoted-text
#confirm sed works for changing the DB_PASSWORD; nesting envvars here...

DBPORIG="'DB_PASSWORD', ''"
DBPNEW="'DB_PASSWORD', '$DB_PASSWORD'"
cd /var/www/html/deploypress
sed -i "
s/'test'/'$DB_NAME'/g
s/'root'/'$DB_USER'/g
s/'$DBPORIG'/'$DBPNEW'/g
s/'put your unique phrase here'/'$AUTH_KEY'/g
s/'put your unique phrase here'/'$SECURE_AUTH_KEY'/g
s/'put your unique phrase here'/'$LOGGED_IN_KEY'/g
s/'put your unique phrase here'/'$NONCE_KEY'/g
s/'put your unique phrase here'/'$AUTH_SALT'/g
s/'put your unique phrase here'/'$SECURE_AUTH_SALT'/g
s/'put your unique phrase here'/'$LOGGED_IN_SALT'/g
s/'put your unique phrase here'/'$NONCE_SALT'/g" wp-config.php

#WordPress permalinks need to use Apache .htaccess files to work 
#properly, but this is not enabled by default on Amazon Linux. Use 
#this procedure to allow all overrides in the Apache document root.

#cd /etc/httpd/conf
#sudo nano httpd.conf
#<Directory "/var/www/html">
#
#    AllowOverride All

#confirm awk works on httpd.conf
cd /etc/httpd/conf
awk '/<Directory \/var\/www\/>/,/AllowOverride None/{sub("None", "All",$0)}{print}'

#create a new root password for MySQL
mysql -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('<your_root_sql_password>'); CREATE DATABASE <your_db_name>; CREATE USER '<your_db_username>'@'localhost'; GRANT ALL PRIVILEGES ON <your_db_name>.* TO '<your_db_username>'@'localhost' IDENTIFIED BY '<your_db_user_password>'; FLUSH PRIVILEGES;"


