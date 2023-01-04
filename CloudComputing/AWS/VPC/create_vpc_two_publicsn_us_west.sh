#!/bin/bash

#set environment variables
export AWS_REGION="us-west-1"
export VPC_NAME="Fargate_Test_VPC"
export VPC_CIDR="10.0.0.0/16"
export SUBNET_PUBLIC_CIDR_0="10.0.1.0/24"
export SUBNET_PUBLIC_AZ_0="us-west-1b"
export SUBNET_PUBLIC_NAME_0="10.0.1.0-us-west-1b"
export SUBNET_PUBLIC_CIDR_1="10.0.0.0/24"
export SUBNET_PUBLIC_AZ_1="us-west-1c"
export SUBNET_PUBLIC_NAME_1="10.0.0.0-us-west-1c"
export SG_NAME="Web_Access"

export SG_DESC="Security group for Web access"

# Step 1: Create a VPC and subnets

# Create VPC
# 1. Create a VPC with a 10.0.0.0/16 CIDR block. 
# aws ec2 create-vpc --cidr-block 10.0.0.0/16  --region "us-west-1"

echo "Creating VPC in preferred region..."

VPC_ID=$(aws ec2 create-vpc  --cidr-block $VPC_CIDR --query 'Vpc.{VpcId:VpcId}' --output text --region $AWS_REGION)
echo "  VPC ID '$VPC_ID' CREATED in '$AWS_REGION' region."
echo "export VPC_ID=$VPC_ID" > env_file

# Add Name tag to VPC

aws ec2 create-tags  --resources $VPC_ID --tags "Key=Name,Value=$VPC_NAME" --region $AWS_REGION
echo "  VPC ID '$VPC_ID' NAMED as '$VPC_NAME'."

# Create Public Subnet

# 2. Using the VPC ID from the previous step, create a subnet with a 10.0.1.0/24 CIDR block. 

echo "Creating Public Subnet..."

SUBNET_PUBLIC_ID_0=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_PUBLIC_CIDR_0 --availability-zone $SUBNET_PUBLIC_AZ_0 --query 'Subnet.{SubnetId:SubnetId}' --output text --region $AWS_REGION)

echo "  Subnet ID '$SUBNET_PUBLIC_ID_0' CREATED in '$SUBNET_PUBLIC_AZ_0'" "Availability Zone."

# Add Name tag to Public Subnet

aws ec2 create-tags --resources $SUBNET_PUBLIC_ID_0 --tags "Key=Name,Value=$SUBNET_PUBLIC_NAME_0" --region $AWS_REGION

echo "  Subnet ID '$SUBNET_PUBLIC_ID_0' NAMED as" "'$SUBNET_PUBLIC_NAME_0'."

# 3. Create a second subnet in your VPC with a 10.0.0.0/24 CIDR block. 

# Create Private Subnet

echo "Creating Private Subnet..."

SUBNET_PUBLIC_ID_1=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_PUBLIC_CIDR_1 --availability-zone $SUBNET_PUBLIC_AZ_1 --query 'Subnet.{SubnetId:SubnetId}' --output text --region $AWS_REGION)

echo "  Subnet ID '$SUBNET_PUBLIC_ID_1' CREATED in '$SUBNET_PRIVATE_AZ_1'" "Availability Zone."

# Add Name tag to Private Subnet

aws ec2 create-tags --resources $SUBNET_PUBLIC_ID_1 --tags "Key=Name,Value=$SUBNET_PUBLIC_NAME_1" --region $AWS_REGION

echo "  Subnet ID '$SUBNET_PUBLIC_ID_1' NAMED as" "'$SUBNET_PUBLIC_NAME_1'."

echo "export SUBNET_PUBLIC_ID_0=$SUBNET_PUBLIC_ID_0" >> env_file

echo "export SUBNET_PUBLIC_ID_1=$SUBNET_PUBLIC_ID_1" >> env_file

# Step 2: Make your subnet public

# 1.  Create Internet gateway

echo "Creating Internet Gateway..."

IGW_ID=$(aws ec2 create-internet-gateway --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' --output text --region $AWS_REGION)

echo "  Internet Gateway ID '$IGW_ID' CREATED."

echo "export IGW_ID=$IGW_ID" >> env_file

# 2. Using the ID from the previous step, attach the Internet gateway to your VPC.

# Attach Internet gateway to your VPC

aws ec2 attach-internet-gateway  --vpc-id $VPC_ID --internet-gateway-id $IGW_ID --region $AWS_REGION

echo "  Internet Gateway ID '$IGW_ID' ATTACHED to VPC ID '$VPC_ID'."

# 3. Create a custom route table for your VPC.

# Create Route Table

echo "Creating Route Table..."

ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.{RouteTableId:RouteTableId}' --output text --region $AWS_REGION)

echo "  Route Table ID '$ROUTE_TABLE_ID' CREATED."

echo "export ROUTE_TABLE_ID=$ROUTE_TABLE_ID" >> env_file

# 4. Create a route in the route table that points all traffic (0.0.0.0/0) to the Internet gateway. 

# Create route to Internet Gateway

RESULT=$(aws ec2 create-route --route-table-id $ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID --region $AWS_REGION)

echo "  Route to '0.0.0.0/0' via Internet Gateway ID '$IGW_ID' ADDED to" "Route Table ID '$ROUTE_TABLE_ID'."

# 5. To confirm that your route has been created and is active, you can describe the route table and view the results. 

aws ec2 describe-route-tables --route-table-id $ROUTE_TABLE_ID

# 6. The route table is currently not associated with any subnet. 

#    You need to associate it with a subnet in your VPC so that traffic from that subnet is routed to the Internet gateway. 

aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query 'Subnets[*].{ID:SubnetId,CIDR:CidrBlock}'

# 7. You can choose which subnet to associate with the custom route table, for example $SUBNET_PUBLIC_ID, . This subnet will be your public subnet. 

# Associate Public Subnet with Route Table

RESULT=$(aws ec2 associate-route-table  --subnet-id $SUBNET_PUBLIC_ID_0 --route-table-id $ROUTE_TABLE_ID --region $AWS_REGION)

echo "  Public Subnet ID '$SUBNET_PUBLIC_ID_0' ASSOCIATED with Route Table ID"  "'$ROUTE_TABLE_ID'."

RESULT=$(aws ec2 associate-route-table  --subnet-id $SUBNET_PUBLIC_ID_1 --route-table-id $ROUTE_TABLE_ID --region $AWS_REGION)

echo "  Public Subnet ID '$SUBNET_PUBLIC_ID_1' ASSOCIATED with Route Table ID"  "'$ROUTE_TABLE_ID'."

# 8. You can optionally modify the public IP addressing behavior of your subnet so that an instance launched into the subnet automatically receives a public IP address. 

# Enable Auto-assign Public IP on Public Subnet

aws ec2 modify-subnet-attribute --subnet-id $SUBNET_PUBLIC_ID_0 --map-public-ip-on-launch --region $AWS_REGION

echo "  'Auto-assign Public IP' ENABLED on Public Subnet ID" "'$SUBNET_PUBLIC_ID_0'."

aws ec2 modify-subnet-attribute --subnet-id $SUBNET_PUBLIC_ID_1 --map-public-ip-on-launch --region $AWS_REGION

echo "  'Auto-assign Public IP' ENABLED on Public Subnet ID" "'$SUBNET_PUBLIC_ID_1'."

echo "Create a Security Group"

#aws ec2 create-security-group --group-name Web_Access --description "Web Access" --vpc-id  $VPC_ID 

aws ec2 create-security-group --group-name "$SG_NAME" --description "$SG_DESC" --vpc-id  "$VPC_ID"

SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" --query "SecurityGroups[?GroupName == '$SG_NAME'].GroupId" --output text)

echo "security group ID is $SECURITY_GROUP_ID"

echo "export export SECURITY_GROUP_ID=$SECURITY_GROUP_ID" >> env_file

# Create ingress rules for your custom security group.

RESULT=$(aws ec2 authorize-security-group-ingress  --group-id $SECURITY_GROUP_ID --protocol tcp --port 22 --cidr 0.0.0.0/0)

RESULT=$(aws ec2 authorize-security-group-ingress  --group-id $SECURITY_GROUP_ID --protocol tcp --port 80 --cidr 0.0.0.0/0)
