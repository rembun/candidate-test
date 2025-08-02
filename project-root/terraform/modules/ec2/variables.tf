variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "sg_jumpbox_id" {
  type = string
}

variable "sg_nodes_id" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "ami_id" {
  type = string
}

variable "key_name" {
  type = string
}

