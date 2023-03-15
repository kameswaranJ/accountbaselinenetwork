#!/bin/bash

# Set the region and VPC CIDR block
name="lz_vpc"
vpcName="$name"
region="us-east-1"
cidr_block="10.0.0.0/16"

# Parameter for ssm
PARAMETER_NAME="/STLA/LZ/vpc-id"

echo "creating vpc"
# Create the VPC
vpc_id=$(aws ec2 create-vpc --cidr-block $cidr_block --region $region --output text --query 'Vpc.VpcId')

echo "name the vpc"
# Add name of tag with vpc
aws ec2 create-tags --resources "$vpc_id" --tags Key=Name,Value="$vpcName" --region $region

#output the vpc id
echo "VPC ID: $vpc_id"

# put the vpc id to ssm
aws ssm put-parameter --name "$PARAMETER_NAME" --value "$vpc_id" --type String --region "$region" --overwrite