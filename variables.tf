# Define variables for the AMI, instance type, and availability zone

variable "ami" {
  type    = string
  default = "ami-0220d79f3f480ecf5"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

# Define variable for region
variable "region" {
  type    = string
  default = "us-east-1"
}

# Define variable for AWS profile
variable "aws_profile" {
  type    = string
  default = "default"
}

# Define variable for VPC CIDR block
variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

# Define variable for key name
variable "key_name" {
  type    = string
  default = "90s-keypair"
}

variable "zone_id" {
  type    = string
  default = "Z0353101YWAUTK0SB32S"
}