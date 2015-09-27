#!/bin/bash

#you must change line 9 below for different AWS regions

yum -y update
yum install -y ruby
yum install -y aws-cli
cd /home/ec2-user
aws s3 cp s3://aws-codedeploy-us-west-2/latest/install . --region us-west-2
chmod +x ./install
./install auto
