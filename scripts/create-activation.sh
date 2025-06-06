#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <robot name>"
    exit 1
fi

default_instance_name=EelNode

aws ssm create-activation \
  --default-instance-name "$default_instance_name" \
  --description "Activation for $default_instance_name" \
  --iam-role service-role/AmazonEC2RunCommandRoleForManagedInstances \
  --registration-limit 10 \
  --region eu-west-1
