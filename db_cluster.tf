## RDS - Global Amazon Aurora Cluster
resource aws_rds_global_cluster "this" {
    count = var.create_global_cluster ? 1 : 0

    global_cluster_identifier = var.global_cluster_name

    engine          = var.engine
    engine_version  = var.engine_version
    database_name   = var.database_name

    deletion_protection = var.deletion_protection
    storage_encrypted = var.storage_encrypted != null ? var.storage_encrypted : ((var.engine_mode == "provisioned") ? false : (var.engine_mode == "serverless" ? true : null))
}

## RDS - Amazon Aurora Cluster
resource aws_rds_cluster "this" {

    count = var.create_cluster ? 1 : 0

    ## Engine options
    engine          = var.engine
    engine_version  = var.engine_version
    engine_mode     = var.engine_mode

    ## Cluster Settings
    global_cluster_identifier = var.global_cluster_name

    cluster_identifier  = var.primary_cluster ? var.cluster_name : null
    master_username     = var.primary_cluster ? var.master_username : null
    master_password     = var.primary_cluster ? local.master_password : null
    
    ## Only applicable for Aurora - secondary cluster (Global Cluster)
    enable_global_write_forwarding = var.primary_cluster ? null : var.enable_global_write_forwarding

    ## Availability & durability
    availability_zones  = var.availability_zones

    ## Connectivity
    port                    = coalesce(var.db_port, (var.engine == "aurora-postgresql" ? 5432 : 3306))
    db_subnet_group_name    = var.create_db_subnet_group ? aws_db_subnet_group.this[0].name : coalesce(var.db_subnet_group_name, "default")
    vpc_security_group_ids  = local.security_groups

    ## Database authentication
    iam_database_authentication_enabled = var.iam_database_authentication_enabled

    ## Additional configuration
    database_name = var.primary_cluster ? var.database_name : null
    db_cluster_parameter_group_name   = var.create_db_cluster_parameter_group ? aws_rds_cluster_parameter_group.this[0].id : lookup(var.db_cluster_parameter_group, "name", null)
    db_instance_parameter_group_name  = var.create_db_parameter_group ? aws_db_parameter_group.this[0].id : lookup(var.db_parameter_group, "name", null)

    enable_http_endpoint  = var.engine_mode == "serverless" ? var.enable_http_endpoint : null
    
    ## Used in case of secondary cluster of global aurora cluster
    source_region         = var.source_region
    
    ## Backup
    backup_retention_period   = var.backup_retention_period
    copy_tags_to_snapshot     = var.copy_tags_to_snapshot
    preferred_backup_window   = var.preferred_backup_window
    snapshot_identifier       = var.snapshot_identifier
    skip_final_snapshot       = var.skip_final_snapshot
    final_snapshot_identifier = !var.skip_final_snapshot ? var.final_snapshot_identifier : null
    
    ## Encryption
    storage_encrypted = var.storage_encrypted != null ? var.storage_encrypted : ((var.engine_mode == "provisioned") ? false : (var.engine_mode == "serverless" ? true : null))
    kms_key_id        = (var.kms_key != null) ? data.aws_kms_key.this[0].arn : null

    ## Backtrack
    backtrack_window = (contains(["aurora", "aurora-mysql"], var.engine) 
                               && var.engine_mode != "serverless") ? var.backtrack_window : 0

    ## Log Exports
    enabled_cloudwatch_logs_exports = var.engine_mode == "serverless" ? null : var.enabled_cloudwatch_logs_exports

    ## Maintenance
    allow_major_version_upgrade   = var.allow_major_version_upgrade
    preferred_maintenance_window  = var.preferred_maintenance_window
    apply_immediately             = var.apply_immediately

    ## Deletion Protection
    deletion_protection = var.deletion_protection

    tags = merge({"Name" = var.cluster_name}, var.default_tags, var.cluster_tags)

    ## Scaling Configurations for Aurora Serverless
    dynamic "scaling_configuration" {
        for_each = (var.engine_mode == "serverless" 
                      && length(keys(var.scaling_configuration)) > 0) ? [1] : []
        content {
          auto_pause               = lookup(var.scaling_configuration, "auto_pause", true)
          max_capacity             = lookup(var.scaling_configuration, "max_capacity", 16)
          min_capacity             = lookup(var.scaling_configuration, "min_capacity", 1)
          seconds_until_auto_pause = lookup(var.scaling_configuration, "seconds_until_auto_pause", 300)
          timeout_action           = lookup(var.scaling_configuration, "timeout_action", "RollbackCapacityChange")
        }
    }

    ## Scaling Configurations for Aurora Provisioned
    dynamic "serverlessv2_scaling_configuration" {
        for_each = (var.engine_mode == "provisioned" 
                      && length(keys(var.serverlessv2_scaling_configuration)) > 0) ? [1] : []
        content {
          max_capacity = lookup(var.serverlessv2_scaling_configuration, "max_capacity", 16)
          min_capacity = lookup(var.serverlessv2_scaling_configuration, "min_capacity", 1)
        }
    }

    lifecycle {
      ignore_changes = [
        global_cluster_identifier,
        availability_zones 
      ]
    }
  
    depends_on = [
        aws_rds_global_cluster.this,
        aws_db_subnet_group.this
    ]
}