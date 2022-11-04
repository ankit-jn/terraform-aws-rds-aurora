locals {
    master_password = (var.primary_cluster && var.generate_password) ? random_string.master_password[0].result : var.master_password
    
    sg_name = coalesce(var.sg_name, format("%s-sg", var.cluster_name))
    sg_ingress_rules_source_sg = [ for sg_id in var.allowed_sg: 
                                            {
                                                rule_name = sg_id
                                                description = format("Allowed for %s", sg_id)
                                                from_port = coalesce(var.db_port, (var.engine == "aurora-postgresql" ? 5432 : 3306))
                                                to_port = coalesce(var.db_port, (var.engine == "aurora-postgresql" ? 5432 : 3306))
                                                protocol = "tcp"
                                                source_security_group_id = sg_id
                                            }
                                ]
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

    rds_monitoring_role_arn = var.enable_enhanced_monitoring ? (
                                !var.create_monitoring_role ? data.aws_iam_role.this[0].arn : module.rds_monitoring_role[0].service_linked_roles[var.monitoring_role_name].arn
                            ) : null


}