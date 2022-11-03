## Cluster Instances
resource aws_rds_cluster_instance "this" {

    for_each = { for instance in var.instances:  instance.name => instance 
                        if var.create_cluster && var.engine_mode != "serverless" } 

    identifier = each.key
    cluster_identifier = aws_rds_cluster.this[0].id

    engine          = var.engine
    engine_version  = var.engine_version
    instance_class  = lookup(each.value, "instance_class", var.instance_class)
    
    availability_zone   = lookup(each.value, "availability_zone", null)
    publicly_accessible = lookup(each.value, "publicly_accessible", var.publicly_accessible)
    promotion_tier      = lookup(each.value, "promotion_tier", 0)

    db_subnet_group_name    = var.create_db_subnet_group ? aws_db_subnet_group.this[0].name : coalesce(var.db_subnet_group_name, "default")
    db_parameter_group_name = var.create_db_parameter_group ? aws_db_parameter_group.this[0].id : lookup(var.db_parameter_group, "name", null)

    ca_cert_identifier = var.ca_cert_identifier

    auto_minor_version_upgrade  = lookup(each.value, "auto_minor_version_upgrade", var.auto_minor_version_upgrade)
    apply_immediately           = lookup(each.value, "apply_immediately", var.apply_immediately)

    monitoring_role_arn = local.rds_monitoring_role_arn
    monitoring_interval = lookup(each.value, "monitoring_granularity", var.monitoring_granularity)

    performance_insights_enabled          = lookup(each.value, "performance_insights_enabled", var.performance_insights_enabled)
    performance_insights_kms_key_id       = (var.performance_insights_kms_key != null) ? data.aws_kms_key.performance_insights[0].arn : null
    performance_insights_retention_period = lookup(each.value, "performance_insights_enabled", var.performance_insights_enabled) ? lookup(each.value, "performance_insights_retention_period", var.performance_insights_retention_period) : null

    preferred_maintenance_window = lookup(each.value, "preferred_maintenance_window", var.preferred_maintenance_window)

    copy_tags_to_snapshot  = lookup(each.value, "copy_tags_to_snapshot", var.copy_tags_to_snapshot)

    tags = merge({"Name" = each.key}, var.default_tags, var.cluster_tags, var.instance_tags, lookup(each.value, "tags", {}))
}

## Cluster Endpoint(s)
resource aws_rds_cluster_endpoint "this" {

    for_each = { for endpoint in var.endpoints:  endpoint.identifier => endpoint 
                        if var.create_cluster && var.engine_mode != "serverless" } 

    cluster_endpoint_identifier = each.key
    custom_endpoint_type        = each.value.type
    cluster_identifier          = aws_rds_cluster.this[0].id

    static_members = can(each.value.static_members) ? flatten([for member in each.value.static_members : aws_rds_cluster_instance.this[member].id]) : null
    excluded_members = can(each.value.excluded_members) ? flatten([for member in each.value.excluded_members : aws_rds_cluster_instance.this[member].id]) : null

    tags = merge({"Name" = each.key}, var.default_tags, var.cluster_tags, lookup(each.value, "tags", {}))

    depends_on = [
        aws_rds_cluster_instance.this
    ]
}
