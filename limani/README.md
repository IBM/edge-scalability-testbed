### Prerequisites
A k8s cluster, which can be created by our playbooks. See [README.md](../README.md).

### Requirements
To run the automation for limani, these items are required:
- Github credentials to get limani code;
- `img_registry` which maps to limani's `IMG_REGISTRY`;
- `img_registry_pswd` which is used to push limani's containers images.

With these, in the root directory of this project, run the following command:
```shell
ansible-playbook -i .data/<host-file-of-the-underlying-cluster-nodes> limani/bootstrap.yaml -e "github_token=<github-credential> img_registry=<somewhere> img_registry_pswd=<random-password>"
```

An one-click, end-to-end example is shown [here](../all-in-one-limani.yaml).
