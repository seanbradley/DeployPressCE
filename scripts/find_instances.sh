#!/bin/bash

aws ec2 describe-instances \
--filters \
'{"Name":"instance-type","Values":["m1.medium"]}' \
'{"Name":"availability-zone","Values":["us-east-1"]}' \
'{"Name":"root-device-type","Values":["ebs"]}' \
--output table

