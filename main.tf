## Random password for Master
resource random_string "master_password" {

    count = var.generate_password ? 1 : 0

    length  = var.password_length
    special = false
}

## Security Group for RDS Aurora
module "rds_security_group" {
    source = "git::https://github.com/ankit-jn/terraform-aws-security-groups.git"

    count = var.create_sg ? 1 : 0

    vpc_id = var.vpc_id
    name = local.sg_name

    ingress_rules = concat(local.sg_ingress_rules, local.sg_ingress_rules_source_sg)
    egress_rules  = local.sg_egress_rules

    tags = merge({"Name" = local.sg_name}, 
                { "AuroraCluster" = var.cluster_name }, var.default_tags)
}

## IAM Role for Enhanced Monitoring
module "rds_monitoring_role" {
    source = "git::https://github.com/ankit-jn/terraform-aws-iam.git"

    count = (var.enable_enhanced_monitoring && var.create_monitoring_role) ? 1 : 0
    
    service_linked_roles  = [local.rds_monitoring_role]
    
    role_default_tags     = merge(var.default_tags, var.monitoring_role_tags)
    policy_default_tags   = var.default_tags
}