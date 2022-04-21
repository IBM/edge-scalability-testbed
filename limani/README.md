### Prerequisites
Self-managed k8s cluster(s) on AWS, which can be created by our playbooks. See [README.md](../README.md).

### Requirements
To run the automation for limani, these items are required:
- Github credentials to get limani code;
- `img_registry` which maps to limani's `IMG_REGISTRY`;
- `img_registry_pswd` which is used to push limani's containers images;
- AWS access key ID and AWS secret access key.


### Deploy Limani Global Infrastructure on AWS

Given a target region (e.g., us-east-2) deploy the infrastructure by following these steps:

1. In the root directory of this project, run the playbook to deploy infrastructure VPC for a give region (e.g., us-east-2)

```shell
ansible-playbook limani/deploy_vpc_infra.yaml -e "vpc_name=limani_pvc region=us-east-2 az_x=us-east-2a az_y=us-east-2c"
```

2. Create the  EC2 instances on AWS. EC2 region and deploy a Kubernetes clusters
```shell
ansible-playbook create-ec2.yaml -e "cluster_name=us-east-2 region=us-east-2 instance_type='t2.xlarge' image_id='ami-0fb653ca2d3203ac1' sig_group=limani-nodes"
ansible-playbook -i .data/hosts_us-east-2 deploy-master.yaml
ansible-playbook -i .data/hosts_us-east-2 deploy-worker.yaml
```

3. Create Global Accelerator (aka Global Load Balancer)
```shell
 ansible-playbook  limani/deploy_global_accelerator.yaml -e "accelerator_name=LimaniAccelerator port_num=31033"
````


### Deploy limani on AWS
Given the k8s clusters are ready, we can deploy limani (at geo-distributed web scale) on AWS, by following these steps:
1. In the root directory of this project, run the playbook to install the base of limani on each of the k8s clusters, including the backend one and all deviceserver ones.
```shell
ansible-playbook -i .data/hosts_limani limani/base.yaml -e "github_token=$GHTOKEN place=aws aws_access_key=$AWS_ACCESS_KEY aws_secret_key=$AWS_SECRET_KEY"
```

2. Finish the setup on the backend cluster. For example:
```shell
ansible-playbook -i .data/hosts_limani limani/backend.yaml -e "img_registry=$DH img_registry_pswd=$DHPSWD place=aws aws_access_key=$AWS_ACCESS_KEY aws_secret_key=$AWS_SECRET_KEY"
```
This creates a 'credentials' container image in ECR to be consumed by the device simulators.

A kubeconfig file for the backend cluster is created by the playbook at `.data/limani_backend_kubeconfig`.

3. Finish the setup on the deviceserver clusters. For example:
```shell
ansible-playbook -i .data/hosts_deviceserver1 limani/deviceserver.yaml -e "img_registry=$DH place=aws aws_access_key=$AWS_ACCESS_KEY aws_secret_key=$AWS_SECRET_KEY"
```

A kubeconfig file for the deviceserver cluster is created by the playbook at `.data/limani_ds_<IP of deviceserver>_kubeconfig`.


### Deploy Limani Simulated Devices Workload

Given a target region (e.g., us-east-2) deploy the simulated devices workload by following these steps:

1. Deploy a network load balancer and attached it to the kubernetes cluster hosting the device servers
```shell
 ansible-playbook limani/deploy_elb_network.yaml -e "region=us-east-2  port_num=31033"
````


2. Add network load balancer region endpoint to the Global Load Balancer
```shell
 ansible-playbook limani/deploy_endpoint_glb_accelerator.yaml -e "region=us-east-2 weight=128"
````

3. Deploy the simulated devices worklod
```shell
 ansible-playbook limani/deploy_agent.yaml -e "region=us-east-2  devicesimulator_image='<example>/devicesimulator'  credentials_image=<aws_ecr>/limani/credentials'"
````


### Destroy the Infrastructure

Given a target region (e.g., us-east-2) destroy the infrastructure by following these steps:

1. Delete region endpoint

```shell
 ansible-playbook limani/delete_endpoint_glb_accelerator.yaml -e "region=us-east-2"
````

2. Delete local load balancer

```shell
ansible-playbook limani/delete_elb_network.yaml -e "region=us-east-2"
````

3. Delete k8s cluster and ec2 hosts

```shell
ansible-playbook delete-ec2.yaml  -e "cluster_name=us-east-2 region=us-east-2 sig_group=limani-nodes"
````

4. Delete agent ECS cluster

```shell
ansible-playbook limani/delete_agent.yaml -e "region=us-east-2"
````

5. Delete VPC

```shell
ansible-playbook limani/delete_vpc_infra.yaml -e "region=us-east-2"
````

6. Delete Global Load Balancer

```shell
 ansible-playbook  limani/delete_global_accelerator.yaml
````


7. Delete Dynamo tables by hand (automation coming soon!)

