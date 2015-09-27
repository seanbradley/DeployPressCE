#!/bin/bash

aws iam add-role-to-instance-profile \
--instance-profile-name DeployPress-6 \
--role-name deploypress_instance_profile_role
