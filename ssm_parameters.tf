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