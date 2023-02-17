#!/bin/bash

# Variables
PARAMETER_NAME="/STLA/LZ/vpc-id"
region="us-east-1"


echo "Get vpc"
# Get vpc id from ssm parameter store
vpc_id=$(aws ssm get-parameter --name $Parameter_name --query "Parameter.Value" --output text --region $region)

echo "delete vpc"
# Delete vpc using parameter input
aws ec2 delete-vpc --vpc-id $vpc_id --region $region

echo "delete ssm"
# Delete parameter store
aws ssm delete-parameter --name $Parameter_name --region $region
