### Prerequisites
Self-managed k8s cluster(s) on AWS, which can be created by our playbooks. See [README.md](../README.md).

### Requirements
To run the automation for limani, these items are required:
- Github credentials to get limani code;
- `img_registry` which maps to limani's `IMG_REGISTRY`;
- `img_registry_pswd` which is used to push limani's containers images;
- AWS access key ID and AWS secret access key.

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
This creates a 'credentials' container images to be consumed by the device simulators.

3. Finish the setup on the deviceserver clusters. For example:
```shell
ansible-playbook -i .data/hosts_deviceserver1 limani/deviceserver.yaml -e "img_registry=$DH place=aws aws_access_key=$AWS_ACCESS_KEY aws_secret_key=$AWS_SECRET_KEY"
```
