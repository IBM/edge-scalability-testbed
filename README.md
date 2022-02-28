Homemade Ansible automation for k8s nodes on AWS EC2
----------------------------------------------------

### Requirements
Requirement of the `ec2instances` role is specified in its [README](roles/ec2instances/README.md).

### Example Usage
1. Create the infrastructure including a security group and EC2 instances on AWS.
EC2 region, numbers of master nodes and worker nodes, and instance type can be specified in playbook `vars`.
```
ansible-playbook create-ec2.yaml -e cluster_name=hub
```

2. Deploy Kubernetes cluster.
```
ansible-playbook -i .data/hosts_hub deploy-master.yaml
ansible-playbook -i .data/hosts_hub deploy-worker.yaml
```

3. Prepare the code repositories ([kealm](https://github.com/pdettori/kealm) and [cymba](https://github.com/pdettori/cymba)) along with their dependencies.
```
ansible-playbook -i .data/hosts_hub prepare-code.yaml
```

4. (Optional) Delete worker nodes from the cluster.
Edit `.data/hosts_hub` by adding the corresponding entries in the `[remove_workers]` Ansible inventory group.
Edit `delete-worker.yaml` by changing the `node_name`, which is shown by `kubectl get nodes`.
Run the playbook:
```
ansible-playbook -i .data/hosts_hub delete-worker.yaml
```

5. Destroy the infrastructure.
```
ansible-playbook delete-ec2.yaml -e cluster_name=hub
```
