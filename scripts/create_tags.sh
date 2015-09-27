#!/bin/bash
#
#requires InstanceID, which is returned after spin_up_instances.sh,
#and/or can be fetched via describe_instances.sh

aws ec2 create-tags \
  --region us-west-2 \
  --resources i-f541b603 \
  --tags Key=Name,Value=DeployPress-6
