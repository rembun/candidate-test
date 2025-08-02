module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "networking" {
  source               = "./modules/networking"
  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  private_subnet_ids   = module.vpc.private_subnet_ids
  vpc_cidr             = var.vpc_cidr
  my_ip                = var.my_ip
}

module "ec2" {
  source              = "./modules/ec2"
  vpc_id              = module.vpc.vpc_id
  public_subnet_id    = module.vpc.public_subnet_ids[0]
  private_subnet_ids  = module.vpc.private_subnet_ids
  sg_jumpbox_id       = module.networking.sg_jumpbox_id
  sg_nodes_id         = module.networking.sg_nodes_id
  availability_zones  = var.availability_zones
  instance_type       = var.instance_type
  ami_id              = var.ami_id
  key_name            = var.key_name
}

module "nlb" {
  source             = "./modules/nlb"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  worker_private_ips = module.ec2.worker_private_ips
}

