variable "cluster_name" {
  default = "devops-cluster"
}
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.123.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = { Name = "${var.cluster_name}-vpc" }
}

resource "aws_internet_gateway" "devops_cluster_igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags   = { Name = "${var.cluster_name}-igw" }
}

variable "public_subnet_cidrs" {
  default = ["10.123.1.0/24", "10.123.2.0/24", "10.123.3.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.123.4.0/24", "10.123.5.0/24", "10.123.6.0/24"]
}
resource "aws_subnet" "public_subnet_a" {
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = var.public_subnet_cidrs[0]
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "${var.cluster_name}-subnet-a" }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = var.public_subnet_cidrs[1]
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "${var.cluster_name}-subnet-b" }
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = var.public_subnet_cidrs[2]
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
  tags = { Name = "${var.cluster_name}-subnet-c" }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = var.private_subnet_cidrs[0]
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "${var.cluster_name}-subnet-a" }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = var.private_subnet_cidrs[1]
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "${var.cluster_name}-subnet-b" }
}
resource "aws_subnet" "private_subnet_c" {
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = var.private_subnet_cidrs[2]
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
  tags = { Name = "${var.cluster_name}-subnet-c" }
}

resource "aws_route_table" "devops_cluster_rt" {
  vpc_id = aws_vpc.eks_vpc.id
  tags   = { Name = "${var.cluster_name}-rt" }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.devops_cluster_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.devops_cluster_igw.id
}

resource "aws_route_table_association" "eks_assoc" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.devops_cluster_rt.id
}

