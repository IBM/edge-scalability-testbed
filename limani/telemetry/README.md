### Prerequisites
Self-managed k8s cluster(s) on AWS with prometheus operator, which can be created by our playbooks. See [README.md](../README.md).

### Requirements
To run the automation for limani, these items are required:
- Github credentials to get limani code;
- AWS access key ID and AWS secret access key;
- AWS CLI installed locally (CLI version with support for timestream command options).


### Configuring Prometheus Operator with remote_write using AWS TimeStream Database (On-going Work)

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
  ansible-playbook -i .data/hosts  limani/telemetry/tdeploy-timestream-adapter.yaml -e "deploy_type=process region=us-east-2 prometheus_database=prometheus-database prometheus_table=prometheus-table metric_path=/metrics"
```

- Option 2: a running pod
```shell
  ansible-playbook -i .data/hosts  limani/telemetry/deploy-timestream-adapter.yaml -e "deploy_type=pod region=us-east-2 prometheus_database=prometheus-database prometheus_table=prometheus-table metric_path=/metrics"
```

5. Create Timestream a k8s secret to store AWS credentials for the prometheus operator - deploy in the prometheus operator namespace (e.g., monitoring):
```shell
  ansible-playbook -i .data/hosts create_timestream_secret.yaml  -e "secret_name=timestream aws_access_key=<access_key> aws_secret_key=<secret_key> k8s_namespace=monitoring"
```

6. Configuring remote_write with prometheus operator:
 i) Find the prometheus manifest configuration: if you deployed prometheus using kube-prometheus, the manifest file will be prometheus-prometheus.yaml in the manifests directory of the kube-prometheus GitHub repo.


 ii) Append the following remote_write configuration block after the version parameter:

 ```shell
  version: 2.34.0
  remoteWrite:
  - url: "<Metrics instance remote_write endpoint> e.g., http://192.168.1.41:9201/write"
    sigv4:
      region: "<timestream_db_region>, e.g., us-east-2"
      accessKey:
        name: kubepromsecret
        key: accessKey
      secretKey:
        name: kubepromsecret
        key: secretKey
 ```

iii) Apply the changes using kubectl:

 ```shell
kubectl apply -f prometheus-prometheus.yaml -n monitoring
```

7. (Optional) Repeat steps 2, 4, 5 and 6 for each region where Prometheus operators are deployed: a single AWS TimeStream database and tables to store the data collected in each regions.


8. (Optional) Install and configure Grafana with the AWS Timestream data source:

i) install: 
```shell
sudo apt update
sudo apt install grafana
grafana-server -v
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
 ```

ii) add Timestream plugin: select authentication provider "AWS SDK Default" to use the default AWS credentials stored at root/.aws/credentials

```shell
grafana-cli plugins install grafana-timestream-datasource
sudo systemctl restart grafana-server
sudo systemctl status grafana-server
```

For further details see tutorial "Visualizing Data in Amazon Timestream using Grafana": https://www.youtube.com/watch?v=pilkz645cs4


### Delete the components depledy to configure Prometheus Operator with remote_write


Given a target region (e.g., us-east-2) delete the infrastructure by following these steps:

1. Delete policy:

```shell
 ansible-playbook limani/telemetry/timestream_policy.yaml  -e "policy_name=prometheus-timestream action=delete"
```

2. Delete AWS timestream table:

```shell
ansible-playbook timestream_tlb.yaml -e "region=us-east-2 db_name=prometheus-database  tbl_name=prometheus-table action=delete"
```

3. Delete AWS timestream database:

```shell
ansible-playbook limani/telemetry/timestream_db.yaml -e "region=us-east-2 db_name=prometheus-database action=delete"
```
