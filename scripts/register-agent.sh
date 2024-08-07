#!/bin/bash

region=eu-west-1
code_secret_id=SsmActivationCode
id_secret_id=SsmActivationId

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <robot name> <code> <id>"
    exit 1
fi

robot_name=$1
code=$2
id=$3

tags="KEY=Name, VALUE=$robot_name"
amazon-ssm-agent -register -code $code -id $id -region $region -tags $tags

echo "Registered agent $robot_name"
echo "Done!"
