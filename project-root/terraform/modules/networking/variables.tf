variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "my_ip" {
  type = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

