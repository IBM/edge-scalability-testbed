### Prerequisites
A k8s cluster, which can be created by our playbooks. See [README.md](../README.md).

### Requirements
To run the automation for limani, these items are required:
- Github credentials to get limani code;
- `img_registry` which maps to limani's `IMG_REGISTRY`;
- `img_registry_pswd` which is used to push limani's containers images.

### Deploy limani on a single k8s cluster and with DynamoDB Local
In the root directory of this project, run the following command to bootstrap limani with Dynamodb Local:
```shell
ansible-playbook -i .data/<host-file-of-the-underlying-cluster-nodes> limani/bootstrap.yaml -e "github_token=<github-credential> img_registry=<somewhere> img_registry_pswd=<my-password>"
```

An one-click, end-to-end example is shown [here](../all-in-one-limani.sh).

### Deploy limani at web scale on AWS
1. In the root directory of this project, run the following command to bootstrap limani:
```shell
ansible-playbook -i .data/<host-file-of-the-underlying-cluster-nodes> limani/bootstrap.yaml -e "github_token=<github-credential> img_registry=<somewhere> img_registry_pswd=<my-password> place=aws aws_region=<my-region> aws_access_key=<my-access-key> aws_secret_key=<my-secret-key>"
```
Here is a concrete example using environment variables:
```shell
ansible-playbook -i .data/hosts_limani limani/bootstrap.yaml -e "github_token=$GHTOKEN img_registry=$DH img_registry_pswd=$DHPSWD place=aws aws_region=$AWS_REGION aws_access_key=$AWS_ACCESS_KEY aws_secret_key=$AWS_SECRET_KEY"
```

2. After the bootstrap, configure the backend k8s cluster. For example:
```
ansible-playbook -i .data/hosts_limani limani/backend.yaml
```
This creates a 'credentials' container images to be consumed by the device simulators.
