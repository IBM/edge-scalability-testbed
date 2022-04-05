### Prerequisites
A k8s cluster, which can be created by our playbooks. See [README.md](../README.md).

### Requirements
To run the automation for limani, these items are required:
- Github credentials to get limani code;
- `img_registry` which maps to limani's `IMG_REGISTRY`;
- `img_registry_pswd` which is used to push limani's containers images.

### Deploy limani on a single k8s cluster and with DynamoDB Local
In the root directory of this project, run the playbook to bootstrap limani with Dynamodb Local:
```shell
ansible-playbook -i .data/hosts_limani limani/base.yaml -e "github_token=$GHTOKEN img_registry=$DH img_registry_pswd=$DHPSWD"
```

### Deploy limani at web scale on AWS
1. In the root directory of this project, run the playbook to bootstrap limani:
```shell
ansible-playbook -i .data/hosts_limani limani/base.yaml -e "github_token=$GHTOKEN img_registry=$DH img_registry_pswd=$DHPSWD place=aws aws_region=$AWS_REGION aws_access_key=$AWS_ACCESS_KEY aws_secret_key=$AWS_SECRET_KEY"
```

2. Configure the backend k8s cluster. For example:
```
ansible-playbook -i .data/hosts_limani limani/backend.yaml
```
This creates a 'credentials' container images to be consumed by the device simulators.

3. Configure the regional k8s cluster. For example:
```
(WIP)
```