
aws ec2 describe-instances --output table --region us-west-1

aws s3 ls --profile profile1

aws configure --profile <profilename>

aws ec2 help

aws ec2 describe-instances help

aws ec2 create-key-pair --key-name 'my key pair'

aws ec2 delete-key-pair --key-name=-mykey

Ref: https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-output-format.html

aws iam list-users 

aws iam list-users --output text
aws iam list-users --output json
aws iam list-users --output table
aws iam list-users --output yaml

aws ec2 stop-instances --instance-ids i-1486157a i-1286157c i-ec3a7e87

aws ec2 create-tags \
    --resources i-1286157c \
    --tags Key=My1stTag,Value=Value1 Key=My2ndTag,Value=Value2 Key=My3rdTag,Value=Value3


aws ec2 describe-instances --query 'Reservations[*].Instances[*].[Placement.AvailabilityZone, State.Name, InstanceId]' --output text
aws ec2 describe-volumes --query 'Volumes[*].{ID:VolumeId,InstanceId:Attachments[0].InstanceId,AZ:AvailabilityZone,Size:Size}' --output table

aws iam list-groups-for-user --user-name susan  --output text --query "Groups[].GroupName"


aws ec2 describe-volumes --query 'Volumes[*]'

