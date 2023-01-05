Ref: https://docs.aws.amazon.com/cli/latest/userguide/cli-services-iam-new-user-group.html


aws iam create-group --group-name MyIamGroup

aws iam create-user --user-name MyUser

aws iam add-user-to-group --user-name MyUser --group-name MyIamGroup

aws iam get-group --group-name MyIamGroup

export POLICYARN=$(aws iam list-policies --query 'Policies[?PolicyName==`PowerUserAccess`].{ARN:Arn}' --output text)       ~
echo $POLICYARN

aws iam attach-user-policy --user-name MyUser --policy-arn $POLICYARN

aws iam list-attached-user-policies --user-name MyUser

aws iam create-login-profile --user-name MyUser --password My!User1Login8P@ssword --password-reset-required

aws iam update-login-profile --user-name MyUser --password My!User1ADifferentP@ssword

aws iam create-access-key --user-name MyUser

aws iam delete-access-key --user-name MyUser --access-key-id AKIAIOSFODNN7EXAMPLE






