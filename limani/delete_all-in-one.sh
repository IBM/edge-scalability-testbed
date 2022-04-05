#!/bin/bash

set -x

# 1st Region: us-east-2
# Delete region endpoint
ansible-playbook delete_endpoint_glb_accelerator.yaml -e "region=us-east-2"

# Delete  Global Accelerator
ansible-playbook  delete_global_accelerator.yaml -e "region=us-east-2"

# Delete device server ECS cluster
ansible-playbook delete_deviceServer_ecs.yaml -e "region=us-east-2 ecs_cluster_name=hub"

# Delete Regional Load Balancer
ansible-playbook delete_elb_network.yaml -e "region=us-east-2"

# Delete VPC
ansible-playbook delete_vpc_infra.yaml -e "region=us-east-2"
