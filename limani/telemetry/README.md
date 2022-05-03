### Prerequisites
Self-managed k8s cluster(s) on AWS with prometheus operator, which can be created by our playbooks. See [README.md](../README.md).

### Requirements
To run the automation for limani, these items are required:
- Github credentials to get limani code;
- AWS access key ID and AWS secret access key;
- AWS CLI installed locally.


### Deploy Limani Global Infrastructure on AWS

Given a target region (e.g., us-east-2) deploy the infrastructure by following these steps:

1. In the root directory of this project, run the playbook to create or delete a AWS TimeStream Database (e.g., us-east-2):

```shell
ansible-playbook limani/telemetry/timestream_db.yaml -e "region=us-east-2 db_name=prometheus-database action=create"
```

2. Create a table in the AWS TimeStream Database created in the previous step:

```shell
 sudo ansible-playbook limani/telemetry/timestream_tlb.yaml -e "region=us-east-2 db_name=prometheus-database  tbl_name=prometheus-table mem_store_retention=1  magnetic_store_retention=1 action=create"
```

3. Create AWS policy to access prometheus Timestream database:
```shell
 ansible-playbook limani/telemetry/timestream_policy.yaml  -e "policy_name=prometheus-timestream action=create"
```

4. Deploy the Timestream adapter in the hosts:

- Option 1: a running process
```shell
  sudo ansible-playbook -i .data/hosts  deploy-timestream-adapter.yaml -e "deploy_type=process region=us-east-2 prometheus_database=prometheus-database prometheus_table=prometheus-table metric_path=/metrics"
```

- Option 2: a running pod
```shell
  sudo ansible-playbook -i .data/hosts  deploy-timestream-adapter.yaml -e "deploy_type=pod region=us-east-2 prometheus_database=prometheus-database prometheus_table=prometheus-table metric_path=/metrics"
```