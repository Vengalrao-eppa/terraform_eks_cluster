## AWS EKS Cluster creation using Terraform
This document is to create a Terraform Configuration to deploy an 
EKS Cluster into AWS.
## Prerequisites
To successfully implement this project you need perform the below steps as a basic requirements

- **AWS Account:** AWS Account with Admin rights assuming you are not using a organisations account
- **AWS CLI:** Installed and configured (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
the link will give you a step by step guide on how to install and configure AWS CLI
- **Terraform:** Install Terraform (https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
A step by step guide for installing Terraform
- **Kubectl:** Kubectl is for kuber cluster management step by step installation giude (https://kubernetes.io/docs/tasks/tools/)

## The Folder structure
```bash
terraform-eks-project/
│── eks/                 
│   ├── network.tf        # VPC, Subnets, Route Tables, IGW
│   ├── security.tf       # Security Groups for EKS & Worker Nodes
│   ├── eks.tf            # EKS Cluster & Node Group
│   ├── eks-role.tf       # Consists of iam roles eks-role & Node-role
│   │── outputs.tf        # Terraform outputs
│── iam/                 
│   ├── ops-user.tf       # IAM Roles & Policies for EKS & OpsUser for Answer 1.B
│── s3/                  
│   ├── s3.tf             # IAM Role & Policy for S3 access for Answer 1.C  
│── variables.tf          # All variable declarations
│── main.tf               # Calls all modules
│── .gitignore            # Ignores Terraform state & sensitive files
│── README.md             # Setup & Project Documentation
```
## Setup Instructions 

1. **Clone the Repo:**
2. **Initialise Terraform**
```bash
   terraform init
```
3. **Generate the execution plan to see what resources are created, modified, destroyed**
```bash
   terraform plan
```
4. **Apply the configuration**
```bash
   terraform apply
```
5. **After deployment use kubectl to interact with the newly created eks cluster**
```bash
  aws eks --region <region-name> update-kubeconfig --name <cluster-name>
```
6. **Verify the cluster by checking the nodes and pods**
```bash
   kubectl get nodes or kubectl get pods
```
6. **Remember to remove all the resources you have created**
```bash
   terraform destroy
```

