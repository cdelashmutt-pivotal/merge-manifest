#!/bin/bash

if [ $# -ne 3 ] || [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
  then
    echo "Copy the cloud_controller, cloud_controller_worker, and clock_global job definitions from a source manifest and replace them in a staged, saving the results to a third file"
    echo 
    echo "Usage: $0 deployed_yaml_filename staged_yaml_filename merged_yaml_filename"
    exit 1
else

  # temp file to store vars
  TEMP_VARS_FILE=$(mktemp /tmp/apply-cc-jobs-script.XXXXXX)

  # remove vars file on exit
  trap "{ rm -f $TEMP_VARS_FILE; }" EXIT  

  DEPLOYED_YAML=$1
  STAGED_YAML=$2
  SCRIPT_PATH=$(dirname $0)

  echo "cloud_controller_yaml:" > $TEMP_VARS_FILE
  sed 's/^/  /' <(bosh int --path=/instance_groups/name=cloud_controller $1) >> $TEMP_VARS_FILE
  echo "clock_global_yaml:" >> $TEMP_VARS_FILE
  sed 's/^/  /' <(bosh int --path=/instance_groups/name=clock_global $1) >> $TEMP_VARS_FILE
  echo "cloud_controller_worker_yaml:" >> $TEMP_VARS_FILE
  sed 's/^/  /' <(bosh int --path=/instance_groups/name=cloud_controller_worker $1) >> $TEMP_VARS_FILE

  bosh int -l $TEMP_VARS_FILE -o $SCRIPT_PATH/replace-cloud-controller.yaml $2 > $3

fi
