#!/bin/bash

echo "Executing Pre-API Helpers"
source env_file

# Set the region and VPC CIDR block

vpcName="$name"
region="$region"
cidr_block="$cidr_block"

# Parameter for ssm
PARAMETER_NAME="$parameter_name"

echo "creating vpc"
# Create the VPC
vpc_id=$(aws ec2 create-vpc --cidr-block $cidr_block --region $region --output text --query 'Vpc.VpcId')

echo "name the vpc"
# Add name of tag with vpc
aws ec2 create-tags --resources "$vpc_id" --tags Key=Name,Value="$name" Key=appid,Value="07224" Key=environment,Value="poc" --region $region

#output the vpc id
echo "VPC ID: $vpc_id"

# put the vpc id to ssm
aws ssm put-parameter --name "$PARAMETER_NAME" --value "$vpc_id" --type String --region "$region" --overwrite

# add tags to ssm resource
aws ssm add-tags-to-resource --resource-type "Parameter" --resource-id $PARAMETER_NAME --tags Key=environment,Value="poc" Key=appid,Value="07224" --region $region
