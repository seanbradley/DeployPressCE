#!/bin/bash
service httpd start
chkconfig httpd on
service mysqld start
chkconfig mysql on
