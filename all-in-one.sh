# tested
ansible-playbook create-ec2.yaml -e "cluster_name=hub"
ansible-playbook create-ec2.yaml -e "cluster_name=managed masters=1 workers=5"
ansible-playbook -i .data/hosts_hub deploy-master.yaml
ansible-playbook -i .data/hosts_hub deploy-worker.yaml
ansible-playbook -i .data/hosts_hub prepare-code.yaml
ansible-playbook -i .data/hosts_managed deploy-master.yaml
ansible-playbook -i .data/hosts_managed deploy-worker.yaml
ansible-playbook -i .data/hosts_managed prepare-code.yaml
ansible-playbook -i .data/hosts_hub create-vhub.yaml -e "vhub_name=vks1"

# work in progress
