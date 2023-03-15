#!/bin/bash

echo "Executing Post-API Helpers"
source env_file
# Variables
PARAMETER_NAME="$parameter_name"
region="$region"


echo "Get vpc"
vpc_id=$(aws ssm get-parameter --name $PARAMETER_NAME --query "Parameter.Value" --region "$region" --output text)

if [ $? -eq 0 ]; then
    echo "Parameter value is $?"
    echo "delete vpc"
    # Delete vpc using parameter input
    aws ec2 delete-vpc --vpc-id "$vpc_id" --region "$region"

    echo "delete ssm"
    # Delete parameter store
    aws ssm delete-parameter --name $PARAMETER_NAME --region "$region"

else
    echo "Error retrieving parameters from SSM"
    exit 1
fi
