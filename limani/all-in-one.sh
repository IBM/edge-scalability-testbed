#!/bin/bash

set -x


#######################################
# 1st Region: us-east-1 (N. Virginia)
#######################################
#ansible-playbook deploy_vpc_infra.yaml -e "vpc_name=hub_pvc region=us-east-1 az_x=us-east-1b az_y=us-east-1c"
#ansible-playbook deploy_elb_network.yaml -e "region=us-east-1  port_num=80 deploy_ecs_device=yes"
#ansible-playbook deploy_deviceServer_ecs.yaml -e "region=us-east-1  port_num=80 container_image='nginx:latest' replicas_count=2"
#ansible-playbook deploy_agent.yaml -e "region=us-east-1 container_image='nginx:latest' replicas_count=2"

# # Create Global Accelerator (aka Global Load Balancer)
# ansible-playbook deploy_global_accelerator.yaml -e "accelerator_name=LimaniAccelerator port_num=80"

# # Add region endpoint
# ansible-playbook deploy_endpoint_glb_accelerator.yaml -e "region=us-east-1 weight=100"



# #################################
# # 2nd Region: us-east-2 (Ohio)
# #################################
# ansible-playbook deploy_vpc_infra.yaml -e "vpc_name=hub_pvc region=us-east-2 az_x=us-east-2a az_y=us-east-2c"
# ansible-playbook deploy_elb_network.yaml -e "region=us-east-2  port_num=80 deploy_ecs_device=yes"
# ansible-playbook deploy_deviceServer_ecs.yaml -e "region=us-east-2  port_num=80 container_image='nginx:latest' replicas_count=2"
#ansible-playbook deploy_agent.yaml -e "region=us-east-2 container_image='nginx:latest' replicas_count=2"

# ansible-playbook create-ec2.yaml -e "cluster_name=hub region=us-east-2 instance_type=t2.2xlarge image_id=ami-0fb653ca2d3203ac1 default_vpc='no' group=hub-nodes"

# # Create Global Accelerator (aka Global Load Balancer)
# ansible-playbook deploy_global_accelerator.yaml -e "accelerator_name=LimaniAccelerator port_num=80"

# # Add region endpoint
# ansible-playbook deploy_endpoint_glb_accelerator.yaml -e "region=us-east-2 weight=100"



##########################################
# 3rd Region: us-west-1 (N. California)
##########################################
ansible-playbook deploy_vpc_infra.yaml -e "vpc_name=limani_pvc region=us-west-1 az_x=us-west-1c az_y=us-west-1b"
ansible-playbook deploy_elb_network.yaml -e "region=us-west-1  port_num=80 deploy_ecs_device=yes"

ansible-playbook ../create-ec2.yaml -e "cluster_name=limani region=us-west-1 instance_type='t2.2xlarge' image_id='ami-009726b835c24a3aa' group=limani-nodes"

#ansible-playbook deploy_deviceServer_ecs.yaml -e "region=us-west-1  port_num=80 container_image='nginx:latest' replicas_count=2"
ansible-playbook deploy_agent.yaml -e "region=us-west-1 container_image='nginx:latest' replicas_count=2"


ansible-playbook ../create-ec2.yaml -e "cluster_name=hub region=us-west-1 instance_type='t2.2xlarge' image_id='ami-009726b835c24a3aa' group=hub-nodes"


# # Create Global Accelerator (aka Global Load Balancer)
# ansible-playbook deploy_global_accelerator.yaml -e "accelerator_name=LimaniAccelerator port_num=80"

# # Add region endpoint
# ansible-playbook deploy_endpoint_glb_accelerator.yaml -e "region=us-west-1 weight=100"
