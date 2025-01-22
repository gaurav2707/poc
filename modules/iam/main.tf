provider "aws" {
  region = var.region  # Change to your desired region
}

########## Role for attaching ec2 instances created  #########
resource "aws_iam_role" "ssm_role" {
  name = "EC2-SSMRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Principal = {
        Service = [
          "ec2.amazonaws.com",
          "ssm.amazonaws.com",
          "backup.amazonaws.com"
        ]
      }
      Effect    = "Allow"
    }]
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
}
 

#####################

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2SSMInstanceProfile_gaurav"
  role = aws_iam_role.ssm_role.name
}