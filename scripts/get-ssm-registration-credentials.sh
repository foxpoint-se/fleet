#!/bin/bash

# usage
# aws-vault exec <YOUR-AWS-PROFILE> exec --
# ./scripts/create-ssm-registration.sh

# instruktioner om att köra alla förutom ett
# kommando utanför. med aws-profil
# det sista behöver man plutta i input

# kan vara sudo-grejen som spökade.
# isåfall kan man köra alla kommandon på ålen direkt
# givet att man har aws-profil
# så behöver printa ut steg 1, 2, 3 typ
# plus: kolla hur faktiskt man gör med att installera agenten
# plus: se till att den sparkar igång efter omstart

region=eu-west-1
code_secret_id=SsmActivationCode
id_secret_id=SsmActivationId

echo "Getting secrets..."
code=$(aws secretsmanager get-secret-value --region $region --secret-id $code_secret_id --query SecretString --output text)
id=$(aws secretsmanager get-secret-value --region $region --secret-id $id_secret_id --query SecretString --output text)

echo "========="
echo "ID: $id"
echo "Code: $code"
echo "On the device you would like to register, do this:"
echo "cd fleet/scripts"
echo "sudo ./register-agent.sh <MY-ROBOT-NAME> $code $id"
# echo "sudo amazon-ssm-agent -register -code $code -id $id -region $region -tags $tags"

# tags="KEY=Name, VALUE=$robot_name"
# amazon-ssm-agent -register -code $code -id $id -region $region -tags $tags

# echo "Registered agent $robot_name"
# echo "Done!"
