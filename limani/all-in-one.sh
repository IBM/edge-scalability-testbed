#!/bin/bash

set -x


# #################################
# # 1nd Region: us-east-2 (Ohio)
# #################################
ansible-playbook deploy_vpc_infra.yaml -e "vpc_name=limani_pvc region=us-east-2 az_x=us-east-2a az_y=us-east-2c"
ansible-playbook ../create-ec2.yaml -e "cluster_name=us-east-2 region=us-east-2 instance_type='t2.2xlarge' image_id='ami-0fb653ca2d3203ac1' sig_group=limani-nodes"

ansible-playbook -i ../.data/hosts_us-east-2 ../deploy-master.yaml
ansible-playbook -i ../.data/hosts_us-east-2 ../deploy-worker.yaml
ansible-playbook -i ../.data/hosts_us-east-2 nginx_test_workload.yaml 

ansible-playbook deploy_elb_network.yaml -e "region=us-east-2  port_num=31033"
ansible-playbook deploy_agent.yaml -e "region=us-east-2 container_image='nginx:latest' replicas_count=2"

### Create Global Accelerator (aka Global Load Balancer) #### 
ansible-playbook deploy_global_accelerator.yaml -e "accelerator_name=LimaniAccelerator port_num=31033"

## Add region endpoint
ansible-playbook deploy_endpoint_glb_accelerator.yaml -e "region=us-east-2 weight=50"



##########################################
# 2nd Region: us-west-1 (N. California)
##########################################

# ansible-playbook deploy_vpc_infra.yaml -e "vpc_name=limani_pvc region=us-west-1 az_x=us-west-1c az_y=us-west-1b"
# ansible-playbook ../create-ec2.yaml -e "cluster_name=us-west-1 region=us-west-1 instance_type='t2.2xlarge' image_id='ami-009726b835c24a3aa' sig_group=limani-nodes"

# ansible-playbook -i ../.data/hosts_us-west-1 ../deploy-master.yaml
# ansible-playbook -i ../.data/hosts_us-west-1 ../deploy-worker.yaml
# ansible-playbook -i ../.data/hosts_us-west-1 nginx_test_workload.yaml 

# ansible-playbook deploy_elb_network.yaml -e "region=us-west-1  port_num=31033"
# ansible-playbook deploy_agent.yaml -e "region=us-west-1 container_image='nginx:latest' replicas_count=2"

# Add region endpoint
# ansible-playbook deploy_endpoint_glb_accelerator.yaml -e "region=us-west-1 weight=25"




#######################################
# 3rd Region: us-west-2 (Oregon)
#######################################
#ansible-playbook deploy_vpc_infra.yaml -e "vpc_name=limani_pvc region=us-west-2 az_x=us-west-2a az_y=us-west-2c"
#ansible-playbook ../create-ec2.yaml -e "cluster_name=us-west-2 region=us-west-2 instance_type='t2.2xlarge' image_id='ami-0892d3c7ee96c0bf7' sig_group=limani-nodes"

# ansible-playbook -i ../.data/hosts_us-west-2 ../deploy-master.yaml
# ansible-playbook -i ../.data/hosts_us-west-2 ../deploy-worker.yaml
# ansible-playbook -i ../.data/hosts_us-west-2 nginx_test_workload.yaml 

#ansible-playbook deploy_elb_network.yaml -e "region=us-west-2  port_num=31033"
#ansible-playbook deploy_agent.yaml -e "region=us-west-2 container_image='nginx:latest' replicas_count=2"

# Add region endpoint
# ansible-playbook deploy_endpoint_glb_accelerator.yaml -e "region=us-west-2 weight=25"
