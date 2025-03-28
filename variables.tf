variable "aws_region" {
  description = "Desired AWS region for deployment of the EKS"
  default     = "us-east-1"  # Change this to your desired region I am using the Eastern US (Northern Virginia)
}

variable "cluster_name" {
  description = "Desired Name of the EKS cluster"
  default     = "devops-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.123.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.123.1.0/24", "10.123.2.0/24", "10.123.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.123.4.0/24", "10.123.5.0/24", "10.123.6.0/24"]
}

variable "instance_type" {
  description = "Instance type for worker nodes"
  type        = list(string)
  default     = ["t3.2xlarge"]
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  default     = 3
}

variable "max_capacity" {
  description = "Maximum number of worker nodes"
  default     = 5
}

variable "min_capacity" {
  description = "Minimum number of worker nodes"
  default     = 2
}
