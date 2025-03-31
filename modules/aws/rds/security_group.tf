resource "aws_security_group" "sg" {
  name        = var.sg_name != "" ? var.sg_name : var.name
  description = var.sg_descr
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allow_sg_ids
    content {
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  dynamic "ingress" {
    for_each = var.allow_cidrs
    content {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  dynamic "egress" {
    for_each = var.allow_egress_cidrs
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [egress.value]
    }
  }

  tags = merge(
    var.tags,
    { Name = format("RDS SG for %s", var.name) }
  )

  lifecycle {
    ignore_changes = [
      name,
      description,
      tags,
    ]
  }
}
