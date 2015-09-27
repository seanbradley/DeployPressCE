#!/bin/bash

aws iam remove-role-from-instance-profile --instance-profile-name DeployPress-5 --role-name dp_service_truster_role
