Ref: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html

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

aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem

chmod 400 MyKeyPair.pem

aws ec2 describe-key-pairs --key-name MyKeyPair

aws ec2 delete-key-pair --key-name MyKeyPair

aws ec2 create-security-group --group-name my-sg --description "My security group" --vpc-id vpc-1a2b3c4d

aws ec2 describe-security-groups --group-ids sg-903004f8

curl https://checkip.amazonaws.com   # It will print the public IP address of your laptop

aws ec2 authorize-security-group-ingress --group-id sg-903004f8 --protocol tcp --port 3389 --cidr x.x.x.x

aws ec2 authorize-security-group-ingress --group-id sg-903004f8 --protocol tcp --port 22 --cidr x.x.x.x

aws ec2 describe-security-groups --group-ids sg-903004f8

aws ec2 delete-security-group --group-id sg-903004f8

aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-903004f8 --subnet-id subnet-6e7f829e

aws ec2 create-tags --resources i-5203422c --tags Key=Name,Value=MyInstance

aws ec2 describe-instances

aws ec2 describe-instances --filters "Name=tag:Name,Values=MyInstance"

aws ec2 describe-instances --filters "Name=image-id,Values=ami-x0123456,ami-y0123456,ami-z0123456"

aws ec2 terminate-instances --instance-ids i-5203422c


