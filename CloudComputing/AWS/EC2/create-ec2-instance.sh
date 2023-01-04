#!/bin/bash
export export SECURITY_GROUP_ID=<SG-ID>
export AWS_AMI_ID=<AMI-ID>
export SUBNET_PUBLIC_ID_0=<SUBNET-ID>
export KEY_PAIR=<Your_Key_Pair>  # without .pem extension
export INSTANCE_TYPE=t2.micro
export USER_DATA=userdata.txt


## Create an EC2 instance
AWS_EC2_INSTANCE_ID=$(aws ec2 run-instances \
--image-id $AWS_AMI_ID \
--instance-type $INSTANCE_TYPE \
--key-name $KEY_PAIR
--monitoring "Enabled=false" \
--security-group-ids $SECURITY_GROUP_ID \
--subnet-id $SUBNET_PUBLIC_ID_0 \
--user-data file://$USER_DATA \
--query 'Instances[0].InstanceId' \
--output text)


echo "Instance ID is $AWS_EC2_INSTANCE_ID"

## Add a tag to the ec2 instance
aws ec2 create-tags \
--resources $AWS_EC2_INSTANCE_ID \
--tags "Key=Name,Value=ppkvpc-ec2-instance"

	
## Check if the instance is running
aws ec2 describe-instance-status \
--instance-ids $AWS_EC2_INSTANCE_ID --output text

AWS_EC2_INSTANCE_PUBLIC_IP=$(aws ec2 describe-instances \
--query "Reservations[*].Instances[*].PublicIpAddress" \
--output=text) 
echo "Instance PUBLIC IP is $AWS_EC2_INSTANCE_PUBLIC_IP"


# Single Command line instruction for creating and terminating

#aws ec2 run-instances --image-id $IMAGE_ID --count 1 --instance-type t2.micro --key-name PPKKeyPair --security-group-ids $SECURITY_GROUP_ID --subnet-id $SUBNET_PUBLIC_ID_0

# Terminate the instance

#aws ec2 terminate-instances --instance-ids "$AWS_EC2_INSTANCE_ID" --output text --query 'TerminatingInstances[*].CurrentState.Name'
