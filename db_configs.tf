## Database Subnet Group
resource aws_db_subnet_group "this" {
    count = var.create_cluster && var.create_db_subnet_group ? 1 : 0
    
    name        = coalesce(var.db_subnet_group_name, format("%s-default", var.cluster_name))
    description = format("DB subnet group for DB cluster - %s", var.cluster_name)
    
    subnet_ids  = var.subnets
}

## Cluster Parameter Group
resource aws_rds_cluster_parameter_group "this" {
    count = var.create_cluster && var.create_db_cluster_parameter_group ? 1 : 0

    name        = var.db_cluster_parameter_group.name
    description = coalesce(var.db_cluster_parameter_group.description, var.db_cluster_parameter_group.name)
    family      = var.db_cluster_parameter_group.family

    dynamic "parameter" {
      for_each = var.db_cluster_parameter_group_parameters

      content {
        name         = parameter.value.name
        value        = parameter.value.value
        apply_method = try(parameter.value.apply_method, "immediate")
      }
    }

    tags = merge(var.default_tags, lookup(var.db_cluster_parameter_group, "tags", {}))
}

## Database Parameter Group
resource aws_db_parameter_group "this" {
    count = var.create_cluster && var.create_db_parameter_group ? 1 : 0

    name        = var.db_parameter_group.name
    description = coalesce(var.db_parameter_group.description, var.db_parameter_group.name)
    family      = var.db_parameter_group.family

    dynamic "parameter" {
      for_each = var.db_parameter_group_parameters

      content {
        name         = parameter.value.name
        value        = parameter.value.value
        apply_method = try(parameter.value.apply_method, "immediate")
      }
    }

    tags = merge(var.default_tags, lookup(var.db_parameter_group, "tags", {}))
}