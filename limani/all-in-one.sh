#!/bin/bash

set -x


##################################
# # Region: us-east-1 (Virginia)
##################################

# ansible-playbook limani/deploy_vpc_infra.yaml -e "vpc_name=limani_pvc region=us-east-1 az_x=us-east-1b az_y=us-east-1c"
# ansible-playbook limani/deploy_agent.yaml -e "region=us-east-1  devicesimulator_image='<img_registry>/devicesimulator'  credentials_image='<aws_account_id>.dkr.ecr.us-west-2.amazonaws.com/limani/credentials'"


##################################
# # 1nd Region: us-east-2 (Ohio)
##################################
# ansible-playbook limani/deploy_vpc_infra.yaml -e "vpc_name=limani_pvc region=us-east-2 az_x=us-east-2a az_y=us-east-2c"
# ansible-playbook create-ec2.yaml -e "cluster_name=us-east-2 region=us-east-2 instance_type='t2.2xlarge' image_id='ami-0fb653ca2d3203ac1' sig_group=limani-nodes"

# ansible-playbook -i .data/hosts_us-east-2 deploy-master.yaml
# ansible-playbook -i .data/hosts_us-east-2 deploy-worker.yaml

# ## Create Global Accelerator (aka Global Load Balancer) #### 
# ansible-playbook  limani/deploy_global_accelerator.yaml -e "accelerator_name=LimaniAccelerator port_num=31033"

# # ansible-playbook -i .data/hosts_us-east-2 limani/test/nginx_test_workload.yaml

# ansible-playbook limani/deploy_agent.yaml -e "region=us-east-2  devicesimulator_image='<img_registry>/devicesimulator'  credentials_image='<aws_account_id>.dkr.ecr.us-west-2.amazonaws.com/limani/credentials'"

# ansible-playbook limani/deploy_elb_network.yaml -e "region=us-east-2  port_num=31033"
# #ansible-playbook limani/deploy_agent.yaml -e "region=us-east-2 devicesimulator_image='nginx:latest' replicas_count=2"

# ## Add region endpoint
# ansible-playbook limani/deploy_endpoint_glb_accelerator.yaml -e "region=us-east-2 weight=100"



##########################################
# 2nd Region: us-west-1 (N. California)
##########################################

# ansible-playbook limani/deploy_vpc_infra.yaml -e "vpc_name=limani_pvc region=us-west-1 az_x=us-west-1c az_y=us-west-1b"
# ansible-playbook create-ec2.yaml -e "cluster_name=us-west-1 region=us-west-1 instance_type='t2.2xlarge' image_id='ami-009726b835c24a3aa' sig_group=limani-nodes"

# ansible-playbook -i .data/hosts_us-west-1 deploy-master.yaml
# ansible-playbook -i .data/hosts_us-west-1 deploy-worker.yaml

# ansible-playbook -i .data/hosts_us-west-1 limani/test/nginx_test_workload.yaml 

# ansible-playbook limani/deploy_elb_network.yaml -e "region=us-west-1  port_num=31033"
# ansible-playbook limani/deploy_agent.yaml  -e "region=us-west-1 container_image='nginx:latest' replicas_count=2"

# # Add region endpoint
# ansible-playbook limani/deploy_endpoint_glb_accelerator.yaml -e "region=us-west-1 weight=25"



#######################################
# 3rd Region: us-west-2 (Oregon)
#######################################
ansible-playbook limani/deploy_vpc_infra.yaml -e "vpc_name=limani_vpc region=us-west-2 az_x=us-west-2a az_y=us-west-2c"
# ansible-playbook create-ec2.yaml -e "cluster_name=us-west-2 region=us-west-2 instance_type='t2.2xlarge' image_id='ami-0892d3c7ee96c0bf7' sig_group=limani-nodes"

# ansible-playbook -i .data/hosts_us-west-2 deploy-master.yaml
# ansible-playbook -i .data/hosts_us-west-2 deploy-worker.yaml

# ansible-playbook -i .data/hosts_us-west-2 limani/test/nginx_test_workload.yaml 

ansible-playbook limani/deploy_agent.yaml -e "region=us-west-2  devicesimulator_image='<img_registry>/devicesimulator'  credentials_image='<aws_account_id>.dkr.ecr.us-west-2.amazonaws.com/limani/credentials'"

# ansible-playbook  limani/deploy_elb_network.yaml -e "region=us-west-2  port_num=31033"
# ansible-playbook limani/deploy_agent.yaml -e "region=us-west-2 container_image='nginx:latest' replicas_count=2"

# # Add region endpoint
# ansible-playbook limani/deploy_endpoint_glb_accelerator.yaml -e "region=us-west-2 weight=25"