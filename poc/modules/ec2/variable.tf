variable "ami_id" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the EC2 instance will be placed"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile for EC2"
  type        = string
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "region" {
  default = "us-east-2"
}

variable "security_group_id" {
  description = "The security group IDs to associate with the EC2 instance."
  type        = list(string)  
}