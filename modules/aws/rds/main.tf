resource "aws_db_parameter_group" "rds-parameters" {
  name        = var.name
  description = "Database parameter group for ${var.name}"
  family      = "postgres${element(split(".", var.engine_version), 0)}"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  tags = merge(
    var.tags,
    {
      Name = format("%s", var.name)
    },
  )

  lifecycle {
    create_before_destroy = false
    ignore_changes = [
      name,
      description,
    ]
  }
}

resource "aws_kms_key" "rds" {
  count        = var.custom_kms_key ? 1 : 0
  multi_region = true
  description  = var.name

  tags = merge(
    var.tags,
    {
      Name = format("%s", var.name)
    },
  )
}

resource "aws_db_instance" "rds" {
  # Unique variables
  allocated_storage          = var.storage_size
  max_allocated_storage      = var.max_storage_size
  instance_class             = var.instance_class
  # # db_name                    = var.db_name
  db_name                    = var.db_replica.is_set ? null : var.db_name  
  identifier                 = var.name
  publicly_accessible        = var.enable_public_access
  snapshot_identifier        = var.from_rds_snapshot_id
  username                   = var.db_replica.is_set ? null : var.username
  password                   = var.db_replica.is_set ? null : var.password
  replicate_source_db        = var.db_replica.is_set ? var.db_replica.source_db : null
  final_snapshot_identifier  = var.skip_final_snapshot ? null : "${var.name}-final"
  skip_final_snapshot        = var.skip_final_snapshot
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  db_subnet_group_name       = (var.db_replica.is_set && !var.db_replica.cross_region) ? coalesce(var.subnet_group_name, var.name) : (var.subnet_group_create ? aws_db_subnet_group.rds[0].name : coalesce(var.subnet_group_name, var.name))

  apply_immediately          = var.apply_immediately
  ca_cert_identifier         = var.ca_cert_identifier
  kms_key_id                 = var.custom_kms_key ? aws_kms_key.rds[0].arn : (var.db_replica.is_set ? var.db_replica.kms_key_arn : null) # https://github.com/hashicorp/terraform/issues/11784

  # Hardcoded values
  storage_type          = var.storage_type
  engine                = var.db_replica.is_set ? null : "postgres"
  storage_encrypted     = var.storage_encrypted
  copy_tags_to_snapshot = var.copy_tags_to_snapshot

  # Calculated variables
  vpc_security_group_ids = [aws_security_group.sg.id]
  parameter_group_name = aws_db_parameter_group.rds-parameters.id

  # Shared variables
  backup_window                       = var.backup_window
  backup_retention_period             = var.backup_retention_period
  maintenance_window                  = var.maintenance_window
  multi_az                            = var.is_multi_az
  engine_version                      = var.db_replica.is_set ? null : var.engine_version
  deletion_protection                 = var.deletion_protection
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period

  lifecycle {
    ignore_changes = [
      identifier,
      password,
      db_subnet_group_name,
      replicate_source_db,
      engine_version,
    ]
  }

  tags = merge(
    var.tags,
    {
      Name = format("%s", var.name)
    },
  )
}
 
resource "aws_db_subnet_group" "rds" {
  count       = var.subnet_group_create ? 1 : 0
  name        = coalesce(var.subnet_group_name, var.name)
  subnet_ids  = var.subnet_ids
  description = var.subnet_group_description

  tags = merge(
    var.tags,
    {
      Name = format("%s", var.name)
    },
  )
}
