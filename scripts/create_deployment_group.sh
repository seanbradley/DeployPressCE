#!/bin/bash
#
#Creates a deployment group and associates it with 
#the specified application and the user's AWS #account. 
#See http://docs.aws.amazon.com/cli/latest/reference/deploy/create-deployment-group.html for more info
#
#format [brackets are optional params]...
#create-deployment-group
#--application-name <value>
#--deployment-group-name <value>
#[--deployment-config-name <value>]
#[--on-premises-instance-tag-filters <value>]
#[--auto-scaling-groups <value>]
#--service-role-arn <value>
#[--ec2-tag-filters <value>]
#[--cli-input-json <value>]
#[--generate-cli-skeleton]
#
#These params can be adjusted at a later time via
#http://docs.aws.amazon.com/codedeploy/latest/userguide/how-to-change-deployment-group-settings.html

aws deploy create-deployment-group \
--application-name DeployPress-6 \
--deployment-config-name CodeDeployDefault.OneAtATime \
--deployment-group-name deploypressdg \
--ec2-tag-filters Key=Name,Value=DeployPress-6,Type=KEY_AND_VALUE \
--service-role-arn arn:aws:iam::234697407490:role/deploypress_service_role
