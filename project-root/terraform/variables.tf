variable "aws_region" {}
variable "vpc_cidr" {
  default = "172.18.0.0/16"
}
variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["172.18.1.0/24", "172.18.2.0/24"]
}
variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["172.18.101.0/24", "172.18.102.0/24"]
}
variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b"]
}
variable "my_ip" {}
variable "key_name" {}
variable "instance_type" {
  default = "t3.medium"
}
variable "ami_id" {
  description = "Ubuntu 24.04 AMI ID for eu-west-1"
}

