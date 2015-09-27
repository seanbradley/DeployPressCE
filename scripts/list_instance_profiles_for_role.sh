#!/bin/bash

aws iam list-instance-profiles-for-role --role-name deploypress_service_role --query "InstanceProfiles[0].InstanceProfileName" --output text
