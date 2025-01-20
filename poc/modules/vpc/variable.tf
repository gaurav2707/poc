variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "subnet_a_cidr" {
  description = "CIDR block for subnet A"
  type        = string
}


variable "az_a" {
  description = "Availability Zone A"
  type        = string
}

variable "region" {
  default = "us-east-2"
}
