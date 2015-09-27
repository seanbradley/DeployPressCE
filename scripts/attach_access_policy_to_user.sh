aws iam put-user-policy \
--user-name GitHub \
--policy-name code_deploy_user_access_policy \
--policy-document file://json/code_deploy_user_access_policy.json
