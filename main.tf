## Random password for Master
resource random_string "master_password" {

    count = var.generate_password ? 1 : 0

    length  = var.password_length
    special = false
}

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
    
    enable_global_write_forwarding = var.enable_global_write_forwarding
    
    ## Instance configuration
    db_cluster_instance_class = var.db_cluster_instance_class

    ## Availability & durability
    availability_zones  = var.availability_zones

    ## Connectivity
    port                    = coalesce(var.db_port, (var.engine == "aurora-postgresql" ? 5432 : 3306))
    db_subnet_group_name    = var.create_db_subnet_group ? aws_db_subnet_group.this[0].name : "default"
    vpc_security_group_ids  = local.security_groups

    ## Database authentication
    iam_database_authentication_enabled = var.iam_database_authentication_enabled

    ## Additional configuration
    database_name = var.database_name
    db_cluster_parameter_group_name   = var.create_db_cluster_parameter_group ? aws_rds_cluster_parameter_group.this[0].id : null
    db_instance_parameter_group_name  = var.create_db_parameter_group ? aws_db_parameter_group.this[0].id : null

    enable_http_endpoint  = var.engine_mode == "serverless" ? var.enable_http_endpoint : null
    
    ## Storage
    storage_type          = var.storage_type
    allocated_storage     = var.allocated_storage
    iops                  = var.iops
    
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
    enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

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
    dynamic "scaling_configuration" {
        for_each = (var.engine_mode == "provisioned" 
                      && length(keys(var.serverlessv2_scaling_configuration)) > 0) ? [1] : []

        content {
          max_capacity             = lookup(var.serverlessv2_scaling_configuration, "max_capacity", 16)
          min_capacity             = lookup(var.serverlessv2_scaling_configuration, "min_capacity", 1)
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

## Security Group for RDS Aurora
module "rds_security_group" {
    source = "git::https://github.com/arjstack/terraform-aws-security-groups.git?ref=v1.0.0"

    count = var.create_sg ? 1 : 0

    vpc_id = var.vpc_id
    name = var.sg_name

    ingress_rules = local.sg_ingress_rules
    egress_rules  = local.sg_egress_rules
}

## Database Subnet Group
resource aws_db_subnet_group "this" {
    count = var.create_db_subnet_group ? 1 : 0
    
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

## IAM Role for Enhanced Monitoring
module "rds_monitoring_role" {
    source = "git::https://github.com/arjstack/terraform-aws-iam.git?ref=v1.0.0"

    count = (var.enable_enhanced_monitoring && var.create_monitoring_role) ? 1 : 0
    
    service_linked_roles  = [local.rds_monitoring_role]
    role_default_tags     = merge(var.default_tags, var.monitoring_role_tags)
}


########################  PARAMETER STORE  ##############################################
## RDS connection parameter are stored in parameter store
## applications can request credentials via this store by using the name
#########################################################################################
resource aws_ssm_parameter "cluster_host" {
    count = (var.create_cluster && var.primary_cluster && var.ssm_cluster_host) ? 1 : 0
    
    name        = format("%s/%s/host", var.ssm_parameter_prefix, var.database_name)
    description = "Host of aurora database"
    type        = "SecureString"
    value       = aws_rds_cluster.this[0].endpoint

    tags = merge({"Name" = format("%s/%s/host", var.ssm_parameter_prefix, var.database_name)}, 
                  var.default_tags, var.cluster_tags)
}

resource aws_ssm_parameter "database_name" {
    count = (var.create_cluster && var.primary_cluster && var.ssm_database_name) ? 1 : 0
    
    name        = format("%s/%s/dbname", var.ssm_parameter_prefix, var.database_name)
    description = "Name of aurora database"
    type        = "SecureString"
    value       = aws_rds_cluster.this[0].database_name

    tags = merge({"Name" = format("%s/%s/dbname", var.ssm_parameter_prefix, var.database_name)}, 
                  var.default_tags, var.cluster_tags)
}

resource aws_ssm_parameter "master_username" {
    count = (var.create_cluster && var.primary_cluster && var.ssm_master_username) ? 1 : 0
    
    name        = format("%s/%s/username", var.ssm_parameter_prefix, var.database_name)
    description = "Username of aurora database"
    type        = "SecureString"
    value       = aws_rds_cluster.this[0].master_username

    tags = merge({"Name" = format("%s/%s/username", var.ssm_parameter_prefix, var.database_name)}, 
                  var.default_tags, var.cluster_tags)
}

resource aws_ssm_parameter "master_password" {
    count = (var.create_cluster && var.primary_cluster && var.ssm_master_password) ? 1 : 0
    
    name        = format("%s/%s/password", var.ssm_parameter_prefix, var.database_name)
    description = "Password of aurora database"
    type        = "SecureString"
    value       = aws_rds_cluster.this[0].master_password

    tags = merge({"Name" = format("%s/%s/password", var.ssm_parameter_prefix, var.database_name)}, 
                  var.default_tags, var.cluster_tags)
}