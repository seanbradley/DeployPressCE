#!/bin/bash
#
#You must get the instance ID from the output of spin_up_instances.sh

aws ec2 describe-instance-status \
--region us-west-2 \
--instance-ids i-f541b603 \
--query "InstanceStatuses[*].InstanceStatus.[Status]" \
--output text 
