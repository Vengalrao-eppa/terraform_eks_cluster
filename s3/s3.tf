resource "aws_iam_role" "order_processor_role" {
  name = "OrderProcessorRole"
  assume_role_policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Principal = { Federated = var.oidc_connect_provider_arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = { "sts.amazonaws.com:sub" = "system:serviceaccount:default:order-processor" }
      }
    }]
  })
}

resource "aws_iam_policy" "s3_read_policy" {
  name        = "S3ReadPolicy"
  description = "Grants read access to the incoming-orders S3 bucket"
  policy      = jsonencode({
    version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:GetObject", "s3:ListBucket"]
      Resource = [
        "arn:aws:s3:::incoming-orders",
        "arn:aws:s3:::incoming-orders/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.order_processor_role.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}


