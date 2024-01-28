#!/bin/bash
certs_folder_name=local_certs_and_config
template_name=config_template.json
config_file_name=iot_config.json
script_path=$(readlink -f "$0")
script_dir=$(dirname "$(readlink -f "$0")")
parent_dir=$(dirname "$script_path")
parent_parent_dir_relative="${script_dir}/.."
parent_parent_dir=$(readlink -f "${parent_parent_dir_relative}")
config_folder_path="${parent_parent_dir}/$certs_folder_name/"
template_path=$parent_parent_dir/$template_name

getThingWithName() {
    name=$1
    jqSelect=$(printf '.things[] | select( .thingName == "%s") ' "$name")
    aws iot list-things | jq -c -r "$jqSelect"
}

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <robot name>"
    exit 1
fi

# Check if AWS credentials are expired
if ! aws sts get-caller-identity &> /dev/null; then
    echo "AWS credentials are expired. Exiting."
    exit 1
fi

robot_name=$1

getThingWithName $robot_name

existing=$(getThingWithName $robot_name)
if [ ! -z "$existing" ]
    then
        echo "$robot_name already exists. Use another name or remove the existing one."
        exit 1
fi

echo "Great! $robot_name is available."

port=8883
endpoint=$(aws iot describe-endpoint --endpoint-type iot:Data-ATS --query endpointAddress --output text)
region=eu-west-1
iotConfigFile=$config_folder_path$config_file_name
priv_key_location=$config_folder_path$robot_name.private.key
cert_file=$config_folder_path$robot_name.cert.pem
root_cert_file=$config_folder_path"rootCA".crt

cat $template_path > $iotConfigFile

sed -i -e "s/ENDPOINT/$endpoint/g" $iotConfigFile
sed -i -e "s/ROOTCA/$(echo $root_cert_file | sed 's_/_\\/_g')/g" $iotConfigFile
sed -i -e "s/PRIVATEKEY/$(echo $priv_key_location | sed 's_/_\\/_g')/g" $iotConfigFile
sed -i -e "s/CERTPATH/$(echo $cert_file | sed 's_/_\\/_g')/g" $iotConfigFile
sed -i -e "s/CLIENT/$robot_name/g" $iotConfigFile
sed -i -e "s/PORT/$port/g" $iotConfigFile
sed -i -e "s/REGION/$region/g" $iotConfigFile

thingArn=$(aws iot create-thing --thing-name $robot_name --query thingArn --output text)
certArn=$(aws iot create-keys-and-certificate --set-as-active \
--certificate-pem-outfile ${config_folder_path}${robot_name}.cert.pem  \
--public-key-outfile ${config_folder_path}${robot_name}.public.key \
--private-key-outfile ${config_folder_path}${robot_name}.private.key \
--query certificateArn --output text)

aws iot attach-thing-principal --principal $certArn --thing-name $robot_name

iot_policy_name=IotFullAccessPolicy
aws iot attach-policy --policy-name $iot_policy_name --target $certArn

curl -sS https://www.amazontrust.com/repository/AmazonRootCA1.pem > $root_cert_file

echo "Done!"
echo ""
echo "Created files:"
echo $root_cert_file
echo $priv_key_location
echo $config_folder_path$robot_name.public.key
echo $cert_file
echo $iotConfigFile
echo ""
echo "Your config looks like this:"
cat $iotConfigFile
echo ""
