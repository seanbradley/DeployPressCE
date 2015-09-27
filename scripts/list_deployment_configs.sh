#can create a custom deployment config with the 
#create-deployment-config command, or use a default #CodeDeployDefault config: e.g., 
#CodeDeployDefault.OneAtATime...which requires all #instances to successfully deploy, rather than a #percentage of the total fleet. 

aws deploy list-deployment-configs
