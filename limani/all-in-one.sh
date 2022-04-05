#!/bin/bash

set -x

# 1st Region: us-east-2
ansible-playbook deploy_vpc_infra.yaml -e "vpc_name=hub_pvc region=us-east-2 az_x=us-east-2a az_y=us-east-2c"
ansible-playbook deploy_elb_network.yaml -e "region=us-east-2  port_num=80 deploy_ecs_device=yes"
ansible-playbook deploy_deviceServer_ecs.yaml -e "region=us-east-2  port_num=80 container_image='nginx:latest' replicas_count=2"

# Create Global Accelerator (aka Global Load Balancer)
ansible-playbook deploy_global_accelerator.yaml -e "accelerator_name=LimaniAccelerator port_num=80"

# Add region endpoint
ansible-playbook deploy_endpoint_glb_accelerator.yaml -e "region=us-east-2 weight=100"
