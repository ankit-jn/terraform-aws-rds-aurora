locals {
    master_password = (var.primary_cluster && var.generate_password) ? random_string.master_password[0].result : var.master_password
    sg_ingress_rules = flatten([ for rule_key, rule in var.sg_rules :  rule if rule_key == "ingress" ])
    sg_egress_rules = flatten([ for rule_key, rule in var.sg_rules :  rule if rule_key == "egress" ])

    additional_sg = coalesce(var.additional_sg, [])
    security_groups = var.create_sg ? concat([module.rds_security_group[0].security_group_id], 
                                                                local.additional_sg) : local.additional_sg
    rds_monitoring_role = {
                            name = var.monitoring_role_name
                            description = "IAM Role for RDS service for enhanced monitoring"
                            service_names = [ "monitoring.rds.amazonaws.com" ] 
                            policy_list = [{
                                            "name"  = "AmazonRDSEnhancedMonitoringRole"
                                            "arn"   = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
                                        }]
                        }
}