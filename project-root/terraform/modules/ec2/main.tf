resource "aws_instance" "jumpbox" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.sg_jumpbox_id]
  key_name               = var.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  tags = {
    Name = "jumpbox"
  }
}

resource "aws_instance" "nodes" {
  count                  = 2
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = element(var.private_subnet_ids, count.index)
  vpc_security_group_ids = [var.sg_nodes_id]
  key_name               = var.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  tags = {
    Name = "k8s-node-${count.index + 1}"
  }
}


