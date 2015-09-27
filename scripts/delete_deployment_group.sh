#!/bin/bash
#
#Output like...
#"hooksNotCleanedUp": []
#...equals success

aws deploy delete-deployment-group --application-name DeployPress-6 --deployment-group-name deploypressdg
