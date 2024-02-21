#!/bin/bash

region=eu-west-1
code_secret_id=SsmActivationCode
id_secret_id=SsmActivationId

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <robot name>"
    exit 1
fi

code=$(aws secretsmanager get-secret-value --region $region --secret-id $code_secret_id --query SecretString --output text)
id=$(aws secretsmanager get-secret-value --region $region --secret-id $id_secret_id --query SecretString --output text)

robot_name=$1

tags="KEY=Name, VALUE=$robot_name"
amazon-ssm-agent -register -code $code -id $id -region $region -tags $tags

echo "Registered agent $robot_name"
echo "Done!"
