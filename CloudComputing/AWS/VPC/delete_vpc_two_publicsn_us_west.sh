#!/bin/bash

# cut and paste from the env_file generated from the create script (create_vpc_two_publicsn_us_west.sh)

export VPC_ID=""

export SUBNET_PUBLIC_ID_0=""

export SUBNET_PUBLIC_ID_1=""

export IGW_ID=""

export ROUTE_TABLE_ID=""

export export SECURITY_GROUP_ID=""

# 1. Delete your security group:

aws ec2 delete-security-group --group-id $SECURITY_GROUP_ID

# 2. Delete your subnets:

aws ec2 delete-subnet --subnet-id $SUBNET_PUBLIC_ID_0

aws ec2 delete-subnet --subnet-id $SUBNET_PUBLIC_ID_1

# 3. Delete your custom route table:

aws ec2 delete-route-table --route-table-id $ROUTE_TABLE_ID

# 4. Detach your Internet gateway from your VPC:

aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID

# 5. Delete your Internet gateway: 

aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID

# 6. Delete your VPC: 

aws ec2 delete-vpc --vpc-id $VPC_ID
