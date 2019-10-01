#!/bin/bash

if [ $# -ne 3 ] || [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
  then
    echo "Copy the cloud_controller, cloud_controller_worker, and clock_global job definitions from a source manifest and replace them in a staged, saving the results to a third file"
    echo 
    echo "Usage: $0 deployed_yaml_filename staged_yaml_filename merged_yaml_filename"
    exit 1
else
  
  DEPLOYED_YAML=$1
  STAGED_YAML=$2

  bosh int --var-file=cloud_controller_yaml=<(bosh int --path=/instance_groups/name=cloud_controller $1) \
    --var-file=clock_global_yaml=<(bosh int --path=/instance_groups/name=clock_global $1) \
    --var-file=cloud_controller_worker_yaml=<(bosh int --path=/instance_groups/name=cloud_controller_worker $1) \
    -o replace-cloud-controller.yaml $2 > $3

fi
