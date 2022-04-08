A scalable Kubernetes-based testbed for edge use cases
------------------------------------------------------

### Requirements
AWS EC2 is the environment used to setup the testbed. So AWS credentials are required.
They can be set by environment variables, e.g. `AWS_ACCESS_KEY` and `AWS_SECRET_KEY`.

### Overview
A very high level overview of the automated components of the testbed is shown [here](overview.txt).
In a nutshell, the testbed consists of (from bottom to top):
- Networking and stroage resources from AWS;
- AWS EC2 instances;
- Kubernetes cluster(s);
- Workload(s).
The [overview](overview.txt) shows a [virtual hub](https://github.com/pdettori/kealm) and a set of [mock clusters](https://github.com/pdettori/cymba) as the workloads.
But the workloads are not limited to this specific use case.

### Quick Start
A one-click bootstrapping of all the [components](overview.txt) can be done by running
```shell
./all-in-one.sh
```

### Examples of Individual Steps
As an alternative to the one-click bootstrapping, we can also run the individual steps as follows.

1. Create the infrastructure including a security group and EC2 instances on AWS.
EC2 region, numbers of master nodes and worker nodes, and instance type can be specified in playbook `vars`.
```
ansible-playbook create-ec2.yaml -e "cluster_name=hub"
ansible-playbook create-ec2.yaml -e "cluster_name=managed"
```

2. Deploy Kubernetes clusters.
```
ansible-playbook -i .data/hosts_hub deploy-master.yaml
ansible-playbook -i .data/hosts_hub deploy-worker.yaml
ansible-playbook -i .data/hosts_managed deploy-master.yaml
ansible-playbook -i .data/hosts_managed deploy-worker.yaml
```

3. Prepare the code repositories ([kealm](https://github.com/pdettori/kealm) and [cymba](https://github.com/pdettori/cymba)) along with their dependencies.
```
ansible-playbook -i .data/hosts_hub prepare-code.yaml
ansible-playbook -i .data/hosts_managed prepare-code.yaml
```

4. Deploy virtual hub.

```
ansible-playbook -i .data/hosts_hub create-vhub.yaml -e "vhub_name=vks1"
```

5. Deploy mocked clusters.

```
ansible-playbook -i .data/hosts_managed deploy-mockclusters.yaml 
```

6. Increase the number of mocked clusters replicas.

```
ansible-playbook -i .data/hosts_managed scale-mockclusters.yaml -e "num_replicas=4"
```

7. The (virtual) hub accepts the join request from the mocked clusters.

```
ansible-playbook -i .data/hosts_hub vhub-approveCSR.yaml 
```

8. (Optional) Delete worker nodes from the cluster.
Edit `.data/hosts_hub` by adding the corresponding entries in the `[remove_workers]` Ansible inventory group.
Edit `delete-worker.yaml` by changing the `node_name`, which is shown by `kubectl get nodes`.
Run the playbook:
```
ansible-playbook -i .data/hosts_hub delete-worker.yaml
```

9. Destroy the infrastructure.
```
ansible-playbook delete-ec2.yaml -e "cluster_name=hub"
ansible-playbook delete-ec2.yaml -e "cluster_name=managed"
```
