#!/bin/bash
#
#Note the value of ARN entry under the Role object
#You'll need it to create a Deployment Group

aws iam get-role \
--role-name deploypress_service_role \
--query "Role.Arn" \
--output text
