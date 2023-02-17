#!/bin/bash
#create aws vpc
# variable used in script
name = "vpc-test"
vpcName = "$name VPC"
VPCCidrBlock = "192.168.0.0/19"


echo "creating vpc"
#creating vpc with cidr block /16
aws_response=$(aws ec2 create-vpc \
 --cidr-block "$vpcCidrBlock" \
 --output json)
vpcId=$(echo -e "$aws_response" |  /usr/bin/jq '.Vpc.VpcId' | tr -d '"')

#name the vpc
aws ec2 create-tags \
  --resources "$vpcId" \
  --tags Key=Name,Value="$vpcName"