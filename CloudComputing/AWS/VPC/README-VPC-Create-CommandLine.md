The commands below is a tutorial on how to create AWS VPC using command line interface

(Ref: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-subnets-commands-example.html)

Step I. Create VPC and Subnets

    Create a VPC with a 10.0.0.0/16 CIDR block using the following create-vpc command. 

aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query Vpc.VpcId --output text

    Using the VPC ID from the previous step, create a subnet with a 10.0.1.0/24 CIDR block using the following create-subnet command. 

aws ec2 create-subnet --vpc-id  <VPC-ID> --cidr-block 10.0.1.0/24

    Create a second subnet in your VPC with a 10.0.0.0/24 CIDR block. 

aws ec2 create-subnet --vpc-id <VPC-ID> --cidr-block 10.0.0.0/24

Step II. Make your Subnet public

    Create an internet gateway using the following create-internet-gateway command. 

aws ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text

    Using the ID from the previous step, attach the internet gateway to your VPC using the following attach-internet-gateway command. 

aws ec2 attach-internet-gateway --vpc-id <VPC-ID> --internet-gateway-id <IGW-ID>

    Create a custom route table for your VPC using the following create-route-table command. 

aws ec2 create-route-table --vpc-id <VPC-ID> --query RouteTable.RouteTableId --output text

    Create a route in the route table that points all traffic (0.0.0.0/0) to the internet gateway using the following create-route command. 

aws ec2 create-route --route-table-id <RTB-ID> --destination-cidr-block 0.0.0.0/0 --gateway-id <IGW-ID>

    To confirm that your route has been created and is active, you can describe the route table using the following describe-route-tables command. 

aws ec2 describe-route-tables --route-table-id <RTB-ID>

    Use the following describe-subnets command to get the subnet IDs. The --filter option restricts the subnets to your new VPC only, and the --query option returns only the subnet IDs and their CIDR blocks. 

aws ec2 describe-subnets --filters "Name=vpc-id,Values=<VPC-ID>" --query "Subnets[*].{ID:SubnetId,CIDR:CidrBlock}"

    You can choose which subnet to associate with the custom route table, for example, <SUBNET-ID0>, and associate it using the associate-route-table command. This subnet is your public subnet. 

aws ec2 associate-route-table  --subnet-id  <SUBNET-ID0> --route-table-id <RTB-ID>

    You can modify the public IP addressing behavior of your subnet so that an instance launched into the subnet automatically receives a public IP address using the following modify-subnet-attribute command. Otherwise, associate an Elastic IP address with your instance after launch so that the instance is reachable from the internet. 

aws ec2 modify-subnet-attribute --subnet-id <SUBNET-ID0> --map-public-ip-on-launch
Step III: Launch an instance into your subnet

    Create a key pair and use the --query option and the --output text option to pipe your private key directly into a file with the .pem extension. 

aws ec2 create-key-pair --key-name MyKeyPair --query "KeyMaterial" --output text > MyKeyPair.pem

chmod 400 MyKeyPair.pem

    Create a security group in your VPC using the create-security-group command. 

aws ec2 create-security-group --group-name SSHAccess --description "Security group for SSH access" --vpc-id <VPC-ID>

Add a rule that allows SSH access from anywhere using the authorize-security-group-ingress command. 

aws ec2 authorize-security-group-ingress --group-id <SG-ID> --protocol tcp --port 22 --cidr 0.0.0.0/0

If you want to restrict just to your laptop run these commands

curl https://checkip.amazonaws.com

aws ec2 authorize-security-group-ingress --group-id <SG-ID> --protocol tcp --port 22 --cidr <IP-ADDRESS from Previous command>

aws ec2 describe-security-groups --group-ids <SG-ID>

    Launch an instance into your public subnet, using the security group and key pair you've created. In the output, take note of the instance ID for your instance. 

aws ec2 run-instances --image-id <AMI-ID>--count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids <SG-ID> --subnet-id <SUBNET-ID0>

AWS image AMI-ID can be obtained by the command below (list two images)

aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-2.0.????????.?-x86_64-gp2" "Name=state,Values=available"  --query "reverse(sort_by(Images, &Name))[:2].ImageId"  --region us-west-1 --output text

Or this command

aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query "Parameters[].Value" --region us-west-1 --output text

    Your instance must be in the running state in order to connect to it. Use the following command to describe the state and IP address of your instance. 

aws ec2 describe-instances --instance-id <INSTANCE-ID> --query "Reservations[*].Instances[*].{State:State.Name,Address:PublicIpAddress}"

    When your instance is in the running state, you can connect to it using an SSH client on a Linux or Mac OS X computer by using the following command: 

ssh -i "MyKeyPair.pem" ec2-user@<IP-ADDRESS>

Step IV: Clean up

    After you've verified that you can connect to your instance, you can terminate it if you no longer need it. To do this, use the terminate-instances command. 

aws ec2 terminate-instances --instance-id <INSTANCE-ID>

aws ec2 delete-security-group --group-id <SG-ID>

    Delete your subnets:

aws ec2 delete-subnet --subnet-id <SUBNET-ID1>

aws ec2 delete-subnet --subnet-id s<SUBNET-ID0>

    Delete your custom route table:

aws ec2 delete-route-table --route-table-id <RTB-ID>

    Detach your internet gateway from your VPC:

aws ec2 detach-internet-gateway --internet-gateway-id <IGW-ID> --vpc-id <VPC-ID>

    Delete your internet gateway:

aws ec2 delete-internet-gateway --internet-gateway-id <IGW-ID>

    Delete your VPC:

aws ec2 delete-vpc --vpc-id <VPC-ID>
