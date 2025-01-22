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
        Principal = 
          Service = [
          "ec2.amazonaws.com",
          "ssm.amazonaws.com",
          "backup.amazonaws.com"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "ssm_policy" {
  name        = "SSMPolicy_gaurav"
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
				        "ssm:PutParameter",
                "ec2messages:*",
                "ssmmessages:*",
                "logs:*",
                "ssm:GetCommandInvocation",
                "ssm:ListCommands",
                "ssm:SendCommand",	
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

resource "aws_iam_role_policy_attachment" "ssm_role_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  depends_on = [aws_iam_role.ssm_role]
}
# Attach AmazonSSMFullAccess policy to the role
resource "aws_iam_role_policy_attachment" "ssm_role_policy_ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  role       = aws_iam_role.ssm_role.name
  depends_on = [aws_iam_role.ssm_role]
}
# Attach AmazonFullAccess policy to the role
resource "aws_iam_role_policy_attachment" "ssm_role_policy_admin" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.ssm_role.name
  depends_on = [aws_iam_role.ssm_role]
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  policy_arn = aws_iam_policy.ssm_policy.arn
  role       = aws_iam_role.ssm_role.name
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2SSMInstanceProfile_gaurav"
  role = aws_iam_role.ssm_role.name
}