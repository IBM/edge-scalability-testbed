#!/bin/bash

set -x

ansible-playbook create-ec2.yaml -e "cluster_name=limani instance_type=t2.2xlarge"
ansible-playbook -i .data/hosts_limani deploy-master.yaml
ansible-playbook -i .data/hosts_limani deploy-worker.yaml

ansible-playbook -i .data/hosts_limani limani/bootstrap.yaml -e "github_token=$GHTOKEN img_registry=$DH img_registry_pswd=$DHPSWD"