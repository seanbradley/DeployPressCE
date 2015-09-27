#!/bin/bash

IP=$(curl http://checkip.amazonaws.com/)

aws ec2 authorize-security-group-ingress --group-name default --protocol ssh --port 80 --cidr $IP/32
