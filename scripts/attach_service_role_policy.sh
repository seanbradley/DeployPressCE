#!/bin/bash
#
#Gives the service role named deploypress_service_role
#permissions based on the IAM managed policy named
#AWSCodeDeployRole; allows AWS CodeDeploy to access your 
#instances to expand (read) their tags or to identify your
#Amazon EC2 instances by the Auto Scaling group names
#that they're associated with.

aws iam attach-role-policy \
--role-name deploypress_service_role \
--policy-arn arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole
