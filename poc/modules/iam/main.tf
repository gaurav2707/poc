provider "aws" {
  region = var.region  # Change to your desired region
}

resource "aws_iam_role" "ssm_role" {
  name = "EC2-SSMRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ssm_policy_gaurav" {
  name        = "SSMPolicy"
  description = "Allow EC2 instances to communicate with Systems Manager"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:DescribeDocument",
                "ssm:GetManifest",
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:ListAssociations",
                "ssm:ListInstanceAssociations",
                "ssm:PutInventory",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action   = "ec2messages:*"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "ssm:ListAssociations"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  policy_arn = aws_iam_policy.ssm_policy.arn
  role       = aws_iam_role.ssm_role.name
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2SSMInstanceProfile"
  role = aws_iam_role.ssm_role.name
}