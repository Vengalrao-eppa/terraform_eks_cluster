# Add an OpsUser IAM role, granting it view only permissions to everything within the ops K8s namespace
# The user arn:aws:iam::1234566789001:user/ops-alice will be using the role from the IP 52.94.236.248

# IAM for Ops User as part of the view only permission
resource "aws_iam_role" "ops_user" {
  name = "OpsUserRole"
  assume_role_policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Principal = { AWS = "arn:aws:iam::XXXXXXXXXXXX:user/terraform_user" }
      Action    = "sts:AssumeRole"
      Condition = {
        IpAddress = { "aws:SourceIp" = ["XX.XX.XXX.XXX"] } #
      }
    }]
  })
}

# IAM Policy for Ops User
resource "aws_iam_policy" "ops_read_policy" {
  name        = "OpsReadPolicy"
  description = "Read-only access to ops namespace"
  policy      = jsonencode({
    version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["eks:Describe*", "eks:List*"]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ops_read_attach" {
  role       = aws_iam_role.ops_user.name
  policy_arn = aws_iam_policy.ops_read_policy.arn
}
