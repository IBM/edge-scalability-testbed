#!/bin/bash

set -x

################################
    # 1st Region: us-east-2
# ################################

# Delete region endpoint
ansible-playbook delete_endpoint_glb_accelerator.yaml -e "region=us-east-2"

# Delete local load balancer
ansible-playbook delete_elb_network.yaml -e "region=us-east-2"

# Delete k8s cluster and ec2 hosts
ansible-playbook ../delete-ec2.yaml -e "cluster_name=us-east-2 region=us-east-2 sig_group=limani-nodes"

# Delete agent ECS cluster
ansible-playbook delete_agent.yaml -e "region=us-east-2"

# Delete VPC
ansible-playbook delete_vpc_infra.yaml -e "region=us-east-2"



################################
    # 2nd Region: us-west-1
################################

# # Delete region endpoint
# ansible-playbook delete_endpoint_glb_accelerator.yaml -e "region=us-west-1"

# # Delete local load balancer
# ansible-playbook delete_elb_network.yaml -e "region=us-west-1"

# Delete k8s cluster and ec2 hosts
# ansible-playbook ../delete-ec2.yaml -e "cluster_name=us-west-1 region=us-west-1 sig_group=limani-nodes"

# # Delete agent ECS cluster
# ansible-playbook delete_agent.yaml -e "region=us-west-1"

# Delete VPC
#ansible-playbook delete_vpc_infra.yaml -e "region=us-west-1"



################################
    # 3rd Region: us-west-2
################################

# # Delete region endpoint
# ansible-playbook delete_endpoint_glb_accelerator.yaml -e "region=us-west-2"

# # Delete local load balancer
# ansible-playbook delete_elb_network.yaml -e "region=us-west-2"

# # Delete k8s cluster and ec2 hosts
# ansible-playbook ../delete-ec2.yaml -e "cluster_name=us-west-2 region=us-west-2 sig_group=limani-nodes"

# # Delete agent ECS cluster
# ansible-playbook delete_agent.yaml -e "region=us-west-2 ecs_cluster_name=agent_simulator"

# # Delete VPC
# ansible-playbook delete_vpc_infra.yaml -e "region=us-west-2"



########################################
    # Delete Global Load Balancer
# #######################################

ansible-playbook  delete_global_accelerator.yaml