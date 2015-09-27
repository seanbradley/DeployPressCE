#!/bin/bash

#Change the region of the instance per your requirments.

scp -i ~/.ssh/<your_keypair>.pem wp-config.local.php ec2-user@ ec2-XX-XXX-XXX-XX.us-west-2.compute.amazonaws.com/var/www/html/deploypress/wp-config.php

#Use the config_db.sh command to mv wp-config.local.php to wp-config.php in post install hooks of the appspec.yml

#this file, and wp-config.local.php should not be included in your repo once it contains actual values


