output "sg_jumpbox_id" {
  value = aws_security_group.jumpbox.id
}

output "sg_nodes_id" {
  value = aws_security_group.nodes.id
}

