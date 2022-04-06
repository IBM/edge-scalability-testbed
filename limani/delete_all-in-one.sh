#!/bin/bash

set -x

# # 1st Region: us-east-2
# # Delete region endpoint
# ansible-playbook delete_endpoint_glb_accelerator.yaml -e "region=us-east-1"

# # Delete  Global Accelerator
# ansible-playbook  delete_global_accelerator.yaml -e "region=us-east-1"

# Delete device server ECS cluster
# ansible-playbook delete_deviceServer_ecs.yaml -e "region=us-east-1 ecs_cluster_name=device_server"

ansible-playbook ../delete-ec2.yaml -e "cluster_name=hub region=us-west-1 group=hub-nodes"



# ansible-playbook delete_agent.yaml -e "region=us-east-1 ecs_cluster_name=agent_simulator"

# # Delete Regional Load Balancer
# ansible-playbook delete_elb_network.yaml -e "region=us-east-1"

# Delete VPC
# ansible-playbook delete_vpc_infra.yaml -e "region=us-east-1"
