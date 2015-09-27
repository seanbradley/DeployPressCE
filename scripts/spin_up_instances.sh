#!/bin/bash
#
#ami-ef35f384 creates an i386 Ubuntu 14.04 LTS "trusty" instance in us-east-1
#ebs-ssd; m1.medium (2 ECUs, 1 vCPUs, Intel Xeon Family, 3.7 GiB memory, 
#1 x 410 GiB Storage Capacity)
#
#ami-ff527ecf creates a paravirtualized, EBS-Backed 64-bit AWS Linux machine
#
#see http://cloud-images.ubuntu.com/locator/ec2/ and #http://aws.amazon.com/amazon-linux-ami/ for options
#
#make a note of the instance ID from the output of this script

aws ec2 run-instances \
  --image-id ami-ff527ecf \
  --region us-west-2 \
  --key-name us-west-2-keypair \
  --user-data file://instance_setup.sh \
  --count 1 \
  --instance-type m1.small \
  --iam-instance-profile Name=DeployPress-6
