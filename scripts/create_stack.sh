#!/bin/bash

aws cloudformation create-stack \
  --stack-name DeployPress-6 \
  --template-url https://s3-us-west-1.amazonaws.com/thunderstorm/WordPress_Multi_AZ.template \
  --parameters \
    ParameterKey=DBPassword,ParameterValue=SecretPizza \
    ParameterKey=KeyName,ParameterValue=cfkeypair \
    ParameterKey=DBUser,ParameterValue=cougarbait \
    ParameterKey=InstanceType,ParameterValue=m1.small \
    ParameterKey=SSHLocation,ParameterValue=0.0.0.0/0 \
  --capabilities CAPABILITY_IAM
