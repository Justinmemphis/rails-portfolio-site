variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID of the VPC in which to create resources."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to launch the instance into."
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair to create in AWS."
  type        = string
}

variable "public_key_path" {
  description = "Path to the public SSH key on your local machine."
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (e.g. Ubuntu 22.04 or Amazon Linux 2)."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "ssh_cidr_block" {
  description = "CIDR block permitted to access the instance via SSH."
  type        = string
  default     = "0.0.0.0/0"
}