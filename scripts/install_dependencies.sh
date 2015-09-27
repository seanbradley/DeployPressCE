#!/bin/bash

#See /var/log/cloud-init.log for troubleshooting.

yum update -y
yum groupinstall -y "Web Server" "MySQL Database" "PHP Support"
yum install -y php-mysql
yum install -y openssh-clients
