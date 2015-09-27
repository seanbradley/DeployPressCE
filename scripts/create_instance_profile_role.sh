aws iam create-role \
--role-name deploypress_instance_profile_role \
--assume-role-policy-document file://json/instance_profile_role_trust.json
