variable "vpc_id" {
  description = "VPC where the NLB will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnets for the NLB"
  type        = list(string)
}

variable "worker_private_ips" {
  description = "List of private IPs of Kubernetes worker nodes"
  type        = list(string)
}

