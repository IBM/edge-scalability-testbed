Homemade Ansible automation for k8s nodes on AWS EC2
----------------------------------------------------

### Requirements
Requirement of the `ec2instances` role is specified in its [README](roles/ec2instances/README.md).

### Example Usage
1. Create the infrastructure including a security group and EC2 instances on AWS.
EC2 region, numbers of master nodes and worker nodes, and instance type can be specified in playbook `vars`.
```
ansible-playbook create-ec2.yaml
```

2. Deploy Kubernetes cluster.
```
ansible-playbook -i .data/hosts deploy-master.yaml
ansible-playbook -i .data/hosts deploy-worker.yaml
```

3. (Optional) Delete worker nodes from the cluster.
Edit `.data/hosts` by adding the corresponding entries in the `[remove_workers]` Ansible inventory group.
Edit `delete-worker.yaml` by changing the `node_name`, which is shown by `kubectl get nodes`.
Run the playbook:
```
ansible-playbook -i .data/hosts delete-worker.yaml
```

4. Destroy the infrastructure.
```
ansible-playbook delete-ec2.yaml
```
