resource "aws_security_group" "devops_cluster_sg" {
  vpc_id = aws_vpc.eks_vpc.id
  tags   = { Name = "${var.cluster_name}-sg" }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.123.0.0/16"]
  }
}
