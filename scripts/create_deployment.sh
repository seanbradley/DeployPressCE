#!/bin/bash

aws deploy create-deployment \
--application-name DeployPress-6 \
--deployment-config-name CodeDeployDefault.OneAtATime \
--deployment-group-name deploypressdg \
--description "DeployPress-6:8." \
--github-location repository=seanbradley/DeployPress,commitId=d0da52c668f6021763f9ff1c8b2c013e962ce4f7
