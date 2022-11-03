# ARJ-Stack: AWS Relational Database Service - Amazon Aurora, Terraform module

A Terraform module for configuring AWS RDS - Amazon Aurora

## Resources
This module features the following components to be provisioned with different combinations:

- Global Amazon Aurora Cluster [[aws_rds_global_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster)]
- Amazon Aurora Cluster [[aws_rds_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster)]
- Cluster Database Instances [[aws_rds_cluster_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance)]
- Cluster Endpoint [[aws_rds_cluster_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_endpoint)]
- Database Subnet Group [[aws_db_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group)]
- Cluster Parameter Group [[aws_rds_cluster_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group)]
- Database Parameter Group [[aws_db_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group)]
- Security Group [[aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)]
- Security Group Rules [[aws_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)]
- RDS Monitoring IAM Role [[aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)]
- SSM Parameters [[aws_ssm_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter)]

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22.0 |

## Examples

Refer [Configuration Examples](https://github.com/arjstack/terraform-aws-examples/tree/main/aws-rds-aurora) for effectively utilizing this module.

## Inputs

#### DB Cluster specific properties
---
| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="create_global_cluster"></a> [create_global_cluster](#input\_create\_global\_cluster) | Flag to decide if create Aurora global database spread across multiple regions | `bool` | `false` | no |  |
| <a name="global_cluster_name"></a> [global_cluster_name](#input\_global\_cluster\_name) | The Global cluster identifier. Required when `create_global_cluster` is set `true` | `string` | `null` | no |  |
| <a name="engine"></a> [engine](#input\_engine) | The name of the database engine to be used for this DB cluster. | `string` | `"aurora"` | no |  |
| <a name="engine_version"></a> [engine_version](#input\_engine\_version) | The database engine version. | `string` | `null` | no |  |
| <a name="engine_mode"></a> [engine_mode](#input\_engine\_mode) | The database engine mode. | `string` | `"provisioned"` | no |  |
| <a name="create_cluster"></a> [create_cluster](#input\_create\_cluster) | Flag to decide if cluster should be provisioned | `bool` | `true` | no |  |
| <a name="primary_cluster"></a> [primary_cluster](#input\_primary\_cluster) | Is the cluster Primary? | `bool` | `true` | no |  |
| <a name="cluster_name"></a> [cluster_name](#input\_cluster\_name) | The cluster identifier. Required when `create_cluster` is set `true` | `string` | `null` | no |  |
| <a name="master_username"></a> [master_username](#input\_master\_username) | Username for the master DB user. | `string` | `"admin"` | no |  |
| <a name="generate_password"></a> [generate_password](#input\_generate\_password) | Flag to decide if random password should be generated for RDS cluster | `bool` | `true` | no |  |
| <a name="password_length"></a> [password_length](#input\_password\_length) | Length of the password if `generate_password` is set true | `number` | `8` | no |  |
| <a name="master_password"></a> [master_password](#input\_master\_password) | Password for master DB user. `generate_password will take preference over this property` | `string` | `null` | no |  |
| <a name="enable_global_write_forwarding"></a> [enable_global_write_forwarding](#input\_enable\_global\_write\_forwarding) | Flag to decide if cluster should forward writes to an associated global cluster. Applied to secondary clusters to enable them to forward writes to an `aws_rds_global_cluster`'s primary cluster | `bool` | `null` | no |  |
| <a name="db_cluster_instance_class"></a> [db_cluster_instance_class](#input\_db\_cluster\_instance\_class) | The compute and memory capacity of each DB instance in the Multi-AZ DB cluster | `string` | `null` | no |  |
| <a name="availability_zones"></a> [availability_zones](#input\_availability\_zones) | List of EC2 Availability Zones for the DB cluster storage where DB cluster instances can be created | `list(string)` | `[]` | no |  |
| <a name="db_port"></a> [db_port](#input\_db\_port) | The port on which the DB accepts connections. | `number` | `null` | no |  |
| <a name="vpc_id"></a> [vpc_id](#input\_vpc\_id) | The ID of VPC that is used to define the virtual networking environment for this DB cluster. | `string` | `""` | no |  |
| <a name="create_db_subnet_group"></a> [create_db_subnet_group](#input\_create\_db\_subnet\_group) | Flag to decide if DB subnet group should be created | `bool` | `true` | no |  |
| <a name="db_subnet_group_name"></a> [db_subnet_group_name](#input\_db\_subnet\_group\_name) | The name of the subnet group name | `string` | `null` | no |  |
| <a name="subnets"></a> [subnets](#input\_subnets) | The list of subnet IDs used by database subnet group | `list(string)` | `[]` | no |  |
| <a name="additional_sg"></a> [additional_sg](#input\_additional\_sg) | List of Existing Security Group IDs associated with Database. | `list(string)` | `[]` | no |  |
| <a name="create_sg"></a> [create_sg](#input\_create\_sg) | Flag to decide to create Security Group for Database | `bool` | `false` | no |  |
| <a name="sg_name"></a> [sg_name](#input\_sg\_name) | The name of the Security group | `string` | `""` | no |  |
| <a name="sg_rules"></a> [sg_rules](#sg\_rules) | Configuration map for Security Group Rules | `map` | `{}` | no | <pre>{<br>   ingress = [<br>      {<br>        rule_name = "Self Ingress Rule"<br>        description = "Self Ingress Rule"<br>        from_port =0<br>        to_port = 0<br>        protocol = "-1"<br>        self = true<br>      },<br>      {<br>        rule_name = "Ingress from IPv4 CIDR"<br>        description = "IPv4 Rule"<br>        from_port = 443<br>        to_port = 443<br>        protocol = "tcp"<br>        cidr_blocks = [<br>          "xx.xx.xx.xx/xx",<br>          "yy.yy.yy.yy/yy"<br>        ]<br>      }<br>   ]<br>   egress =[<br>      {<br>        rule_name = "Self Egress Rule"<br>        description = "Self Egress Rule"<br>        from_port =0<br>        to_port = 0<br>        protocol = "-1"<br>        self = true<br>      }<br>   ]<br>} |
| <a name="iam_database_authentication_enabled"></a> [iam_database_authentication_enabled](#input\_iam\_database\_authentication\_enabled) | Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled | `bool` | `null` | no |  |
| <a name="database_name"></a> [database_name](#input\_database_name) | Name for an automatically created database on cluster creation. | `string` |  | yes |  |
| <a name="enable_http_endpoint"></a> [enable_http_endpoint](#input\_enable\_http\_endpoint) | Enable HTTP endpoint (data API) | `string` | `null` | no |  |
| <a name="storage_type"></a> [storage_type](#input\_storage\_type) | Specifies the storage type to be associated with the DB cluster. | `string` | `null` | no |  |
| <a name="allocated_storage"></a> [allocated_storage](#input\_allocated\_storage) | The amount of storage in gibibytes (GiB) to allocate to each DB instance in the Multi-AZ DB cluster. | `number` | `null` | no |  |
| <a name="iops"></a> [iops](#input\_iops) | The amount of Provisioned IOPS to be initially allocated for each DB instance in the Multi-AZ DB cluster. | `number` | `null` | no |  |
| <a name="source_region"></a> [source_region](#input\_source\_region) | The source region for an encrypted replica DB cluster. | `string` | `null` | no |  |
| <a name="backup_retention_period"></a> [backup_retention_period](#input\_backup\_retention\_period) | The days to retain backups for. | `number` | `1` | no |  |
| <a name="copy_tags_to_snapshot"></a> [copy_tags_to_snapshot](#input\_copy\_tags\_to\_snapshot) | Copy all tags from DB cluster to snapshots. | `bool` | `false` | no |  |
| <a name="preferred_backup_window"></a> [preferred_backup_window](#input\_preferred\_backup\_window) | The daily time range (in UTC) during which automated backups are created if automated backups are enabled using the backup_retention_period. | `string` | `null` | no |  |
| <a name="snapshot_identifier"></a> [snapshot_identifier](#input\_snapshot\_identifier) | Specifies whether or not to create this cluster from a snapshot. | `string` | `null` | no |  |
| <a name="skip_final_snapshot"></a> [skip_final_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB cluster is deleted. | `bool` | `false` | no |  |
| <a name="final_snapshot_identifier"></a> [final_snapshot_identifier](#input\_final\_snapshot\_identifier) | The name of your final DB snapshot when this DB cluster is deleted. | `string` | `null` | no |  |
| <a name="storage_encrypted"></a> [storage_encrypted](#input\_storage\_encrypted) | Specifies whether the DB cluster is encrypted. | `bool` | `null` | no |  |
| <a name="kms_key"></a> [kms_key](#input\_kms\_key) | The reference of the KMS key to use for encryption | `string` | `null` | no |  |
| <a name="backtrack_window"></a> [backtrack_window](#input\_backtrack\_window) | The target backtrack window, in seconds. | `number` | `0` | no |  |
| <a name="enabled_cloudwatch_logs_exports"></a> [enabled_cloudwatch_logs_exports](#input\_enabled\_cloudwatch\_logs\_exports) | Set of log types to export to cloudwatch. | `set(string)` | `[]` | no |  |
| <a name="allow_major_version_upgrade"></a> [allow_major_version_upgrade](#input\_allow\_major\_version\_upgrade) | Enable to allow major engine version upgrades when changing engine versions. | `bool` | `false` | no |  |
| <a name="preferred_maintenance_window"></a> [preferred_maintenance_window](#input\_preferred\_maintenance\_window) | The weekly time range during which system maintenance can occur, in (UTC). | `string` | `null` | no |  |
| <a name="apply_immediately"></a> [apply_immediately](#input\_apply\_immediately) | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. | `bool` | `false` | no |  |
| <a name="deletion_protection"></a> [deletion_protection](#input\_deletion\_protection) | Flag to decide if the DB instance should have deletion protection enabled. | `bool` | `false` | no |  |
| <a name="scaling_configuration"></a> [scaling_configuration](#scaling\_configuration) | Map of the following Scaling configuirations for Serverless Engine mode. | `map(string)` | `{}` | no |  |
| <a name="serverlessv2_scaling_configuration"></a> [serverlessv2_scaling_configuration](#serverlessv2\_scaling\_configuration) | Map of the Scaling configuirations for Provisioned Engine mode. | `map(string)` | `{}` | no |  |
| <a name="create_db_cluster_parameter_group"></a> [create_db_cluster_parameter_group](#input\_create\_db\_cluster\_parameter\_group) | Flag to decide if a new cluster parameter group should be created | `bool` | `false` | no |  |
| <a name="db_cluster_parameter_group"></a> [db_cluster_parameter_group](#parameter\_group) | The configuration map of the DB cluster parameter group | `map` | `{}` | no |  |
| <a name="db_cluster_parameter_group_parameters"></a> [db_cluster_parameter_group_parameters](#parameter\_group\_parameters) | A list of DB cluster parameter group parameters map to apply | `list(map(string))` | `[]` | no |  |
| <a name="create_db_parameter_group"></a> [create_db_parameter_group](#input\_create\_db\_parameter\_group) | Flag to decide if a new database instance parameter group should be created | `bool` | `false` | no |  |
| <a name="db_parameter_group"></a> [db_parameter_group](#parameter\_group) | The configuration map of the DB instance parameter group | `map` | `{}` | no |  |
| <a name="db_parameter_group_parameters"></a> [db_parameter_group_parameters](#parameter\_group\_parameters) | A list of DB parameters map to apply | `list(map(string))` | `[]` | no |  |

#### DB Instance specific properties
---
| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="instance_class"></a> [instance_class](#input\_instance\_class) | The compute and memory capacity of each DB instance in the Multi-AZ DB cluster | `string` | `null` | no |  |
| <a name="publicly_accessible"></a> [publicly_accessible](#input\_publicly\_accessible) | Flag to decide if instances are publicly accessible | `bool` | `false` | no |  |
| <a name="auto_minor_version_upgrade"></a> [auto_minor_version_upgrade](#input\_auto\_minor\_version\_upgrade) | Enable to allow minor engine upgrades utomatically to the DB instance during the maintenance window. | `bool` | `true` | no |  |
| <a name="enable_enhanced_monitoring"></a> [enable_enhanced_monitoring](#input\_enable\_enhanced\_monitoring) | Flag to decide if enhanced monitoring should be enabled | `bool` | `false` | no |  |
| <a name="monitoring_granularity"></a> [monitoring_granularity](#input\_monitoring\_granularity) | Monitoring Interval, in seconds, to apply on each DB instance | `number` | `0` | no |  |
| <a name="create_monitoring_role"></a> [create_monitoring_role](#input\_create\_monitoring\_role) | Flag to decide if IAM role to be created for monitoring | `bool` | `false` | no |  |
| <a name="monitoring_role_name"></a> [monitoring_role_name](#input\_monitoring\_role\_name) | RDS Monitoring Role Name | `string` | `"rds-monitoring-role"` | no |  |
| <a name="performance_insights_enabled"></a> [performance_insights_enabled](#input\_performance\_insights\_enabled) | Specifies whether Performance Insights is enabled or not | `bool` | `false` | no |  |
| <a name="performance_insights_kms_key"></a> [performance_insights_kms_key](#input\_performance\_insights\_kms\_key) | The reference of the KMS key to encrypt Performance Insights data. | `string` | `null` | no |  |
| <a name="performance_insights_retention_period"></a> [performance_insights_retention_period](#input\_performance\_insights\_retention\_period) | Amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years) | `number` | `7` | no |  |
| <a name="instances"></a> [instances](#instances) | List of cluster instances map | `list` | `[]` | no |  |
| <a name="endpoints"></a> [endpoints](#endpoints) | List of cluster endpoints map | `list` | `[]` | no |  |

#### Tags specific properties
---
| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="default_tags"></a> [default_tags](#input\_default\_tags) | A map of tags to assign to all the resources. | `map(string)` | `{}` | no |  |
| <a name="cluster_tags"></a> [cluster_tags](#input\_cluster\_tags) | A map of tags to assign to the DB cluster. | `map(string)` | `{}` | no |  |
| <a name="instance_tags"></a> [instance_tags](#input\_instance\_tags) | A map of tags to assign to all the DB Instance. | `map(string)` | `{}` | no |  |
| <a name="monitoring_role_tags"></a> [monitoring_role_tags](#input\_monitoring\_role\_tags) | A map of tags to assign to the Monitoring IAM Role. | `map(string)` | `{}` | no |  |

#### SSM Parameter specific properties
---
| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="ssm_parameter_prefix"></a> [ssm_parameter_prefix](#input\_ssm\_parameter\_prefix) | Prefix for SSM paramteres | `string` | `""` | no |  |
| <a name="ssm_cluster_host"></a> [ssm_cluster_host](#input\_ssm\_cluster\_host) | Flag to decide if the cluster_host should be stored as SSM parameter | `bool` | `true` | no |  |
| <a name="ssm_database_name"></a> [ssm_database_name](#input\_ssm\_database\_name) | Flag to decide if the database_name should be stored as SSM parameter | `bool` | `true` | no |  |
| <a name="ssm_master_username"></a> [ssm_master_username](#input\_ssm\_master\_username) | Flag to decide if the master_username should be stored as SSM parameter | `bool` | `true` | no |  |
| <a name="ssm_master_password"></a> [ssm_master_password](#input\_ssm\_master\_password) | Flag to decide if the master_password should be stored as SSM parameter | `bool` | `true` | no |  |

## Nested Configuration Maps:  

#### scaling_configuration

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="auto_pause"></a> [auto_pause](#input\_auto\_pause) | Whether to enable automatic pause. | `bool` | `true` | no |
| <a name="max_capacity"></a> [max_capacity](#input\_max\_capacity) | The maximum capacity for an Aurora DB cluster in serverless DB engine mode. | `number` | `16` | no |
| <a name="min_capacity"></a> [min_capacity](#input\_min\_capacity) | The minimum capacity for an Aurora DB cluster in serverless DB engine mode. | `number` | `1` | no |
| <a name="seconds_until_auto_pause"></a> [seconds_until_auto_pause](#input\_seconds\_until\_auto\_pause) | The time, in seconds, before an Aurora DB cluster in serverless mode is paused. | `number` | `300` | no |
| <a name="timeout_action"></a> [timeout_action](#input\_timeout\_action) | The action to take when the timeout is reached. | `string` | `RollbackCapacityChange` | no |

#### serverlessv2_scaling_configuration

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="max_capacity"></a> [max_capacity](#input\_max\_capacity) | The maximum capacity for an Aurora DB cluster in provisioned DB engine mode. | `number` | `16` | no |
| <a name="min_capacity"></a> [min_capacity](#input\_min\_capacity) | The minimum capacity for an Aurora DB cluster in provisioned DB engine mode. | `number` | `1` | no |

#### parameter_group

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="name"></a> [name](#input\_name) | The name of the DB parameter group. | `string` |  | yes |
| <a name="family"></a> [family](#input\_family) | The family of the DB parameter group | `string` |  | yes |
| <a name="description"></a> [description](#input\_description) | The description of the DB parameter group. | `string` |  | no |
| <a name="tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `string` | `{}` | no |

#### parameter_group_parameters
| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="name"></a> [name](#input\_name) | The name of the DB parameter. | `string` |  | yes |
| <a name="value"></a> [value](#input\_value) | The value of the DB parameter. | `string` |  | yes |
| <a name="apply_method"></a> [apply_method](#input\_apply\_method) | "immediate" (default), or "pending-reboot". | `string` | `immediate` | no |

#### instances

- Instance properties defined here are used to override the properties defined commonly for all instances or at the cluster level, e.g.
    - `publicly_accessible` defined at instance level is used to override the commom properties for instances `publicly_accessible` 
    - ...

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="name"></a> [name](#input\_name) | The identifier for the RDS instance | `string` |  | yes |
| <a name="instance_class"></a> [instance_class](#input\_instance\_class) | The instance class to use. | `string` |  | yes |
| <a name="availability_zone"></a> [availability_zone](#input\_availability\_zone) | The EC2 Availability Zone that the DB instance is created in. | `string` |  | no |
| <a name="publicly_accessible"></a> [publicly_accessible](#input\_publicly\_accessible) | Flag to control if instance is publicly accessible. | `bool` |  | no |
| <a name="promotion_tier"></a> [promotion_tier](#input\_promotion\_tier) | Failover Priority setting on instance level. | `number` | `0` | no |
| <a name="auto_minor_version_upgrade"></a> [auto_minor_version_upgrade](#input\_auto\_minor\_version\_upgrade) | Enable to allow minor engine upgrades utomatically to the DB instance during the maintenance window. | `bool` |  | no |
| <a name="apply_immediately"></a> [apply_immediately](#input\_apply\_immediately) | Specifies whether any database modifications are applied immediately, or during the next maintenance window. | `bool` |  | no |
| <a name="monitoring_granularity"></a> [monitoring_granularity](#input\_monitoring\_granularity) | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. | `number` |  | no |
| <a name="preferred_maintenance_window"></a> [preferred_maintenance_window](#input\_preferred\_maintenance\_window) | The window to perform maintenance in. | `string` |  | no |
| <a name="performance_insights_enabled"></a> [performance_insights_enabled](#input\_performance\_insights\_enabled) | Specifies whether Performance Insights is enabled or not. | `bool` |  | no |
| <a name="performance_insights_retention_period"></a> [performance_insights_retention_period](#input\_performance\_insights\_retention\_period) | Amount of time in days to retain Performance Insights data. | `number` |  | no |
| <a name="copy_tags_to_snapshot"></a> [copy_tags_to_snapshot](#input\_copy\_tags\_to\_snapshot) | Copy all tags from DB instance to snapshots. | `bool` |  | no |
| <a name="tags"></a> [tags](#input\_tags) | A map of tags to assign to the DB Instance. | `map(string)` | `{}` | no |

#### endpoints

- Either `static_members` or `excluded_members` can be specified as they conflict with each other

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="identifier"></a> [identifier](#input\_identifier) |  | `string` |  | yes |
| <a name="type"></a> [type](#input\_type) |  | `string` |  | yes |
| <a name="static_members"></a> [static_members](#input\_static\_members) | List of DB instance identifiers that are part of the custom endpoint group. | `list(string)` | `null` | no |
| <a name="excluded_members"></a> [excluded_members](#input\_excluded\_members) | List of DB instance identifiers that are not part of the custom endpoint group. | `list(string)` | `null` | no |
| <a name="tags"></a> [tags](#input\_tags) | A map of tags to assign to the custom endpoint. | `map(string)` | `{}` | no |

#### sg_rules
[ Ingress / Egress ]

- `cidr_blocks` Cannot be specified with `source_security_group_id` or `self`.
- `ipv6_cidr_blocks` Cannot be specified with `source_security_group_id` or `self`.
- `source_security_group_id` Cannot be specified with `cidr_blocks`, `ipv6_cidr_blocks` or `self`.
- `self` Cannot be specified with `cidr_blocks`, `ipv6_cidr_blocks` or `source_security_group_id`.

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="rule_name"></a> [rule_name](#input\_rule\_name) | The name of the Rule (Used for terraform perspective to maintain unicity) | `string` |  | yes |
| <a name="description"></a> [description](#input\_description) | Description of the rule. | `string` |  | yes |
| <a name="from_port"></a> [from_port](#input\_from\_port) | Start port (or ICMP type number if protocol is "icmp" or "icmpv6"). | `number` |  | yes |
| <a name="to_port"></a> [to_port](#input\_to\_port) | End port (or ICMP code if protocol is "icmp"). | `number` |  | yes |
| <a name="protocol"></a> [protocol](#input\_protocol) | Protocol. If not icmp, icmpv6, tcp, udp, or all use the protocol number | `string \| number` |  | yes |
| <a name="self"></a> [self](#input\_self) | Whether the security group itself will be added as a source to this ingress rule.  | `bool` |  | no |
| <a name="cidr_blocks"></a> [cidr_blocks](#input\_cidr\_blocks) | List of IPv4 CIDR blocks | `list(string)` |  | no |
| <a name="ipv6_cidr_blocks"></a> [ipv6_cidr_blocks](#input\_ipv6\_cidr\_blocks) | List of IPv6 CIDR blocks. | `list(string)` |  | no |
| <a name="source_security_group_id"></a> [source_security_group_id](#input\_source\_security\_group\_id) | Security group id to allow access to/from | `string` |  | no |

## Outputs

| Name | Type | Description |
|:------|:------|:------|
| <a name="global_cluster_arn"></a> [global_cluster_arn](#output\_global\_cluster\_arn) | `string` | RDS Global Cluster Amazon Resource Name (ARN) |
| <a name="cluster_arn"></a> [cluster_arn](#output\_cluster\_arn) | `string` | RDS Cluster Amazon Resource Name (ARN) |
| <a name="port"></a> [port](#output\_port) | `number` | Database Port |
| <a name="db_subnet_group"></a> [db_subnet_group](#output\_db\_subnet\_group) | `map` | Database Subnet Group Map:<br>&nbsp;&nbsp;`id` - The ID/Name of DB Subnet Group<br>&nbsp;&nbsp;`arn` - Amazon Resource Name (ARN) of SB Subnet group |
| <a name="instances"></a> [instances](#output\_instances) | `map` | RDS Aurora Cluster Instances:<br><b>Map Key:</b> Instance Identifier<br><b>Map Value:</b> Map of the following Instance attributes:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`id` - The ID of Instance<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`arn` - Amazon Resource Name (ARN) of Instance<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`endpoint` - Endpoint of the instance<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`writer` - Whether instance is for writing purpose of for Read replica |
| <a name="cluster_endpoint"></a> [cluster_endpoint](#output\_cluster\_endpoint) | `string` | RDS Aurora Cluster Endpint |
| <a name="custom_endpoints"></a> [custom_endpoints](#output\_custom\_endpoints) | `map` | RDS Aurora Cluster Custom Endpints:<br><b>Map Key:</b> Endpoint Identifier<br><b>Map Value:</b> Map of the following Custom Endpoint attributes:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`id` - The ID of Custom Endpoint<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`arn` - Amazon Resource Name (ARN) of Custom Endpoint<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`endpoint` - Endpoint |
| <a name="rds_monitoring_role"></a> [rds_monitoring_role](#output\_rds\_monitoring\_role) | `map` | IAM role created for RDS enhanced monitoring |
| <a name="ssm_paramter_cluster_host"></a> [ssm_paramter_cluster_host](#output\_ssm\_paramter\_cluster\_host) | `string` | The SSM Parameter ARN for cluster Host |
| <a name="ssm_paramter_database_name"></a> [ssm_paramter_database_name](#output\_ssm\_paramter\_database\_name) | `string` | The SSM Parameter ARN for Database name |
| <a name="ssm_paramter_master_username"></a> [ssm_paramter_master_username](#output\_ssm\_paramter\_master\_username) | `string` | The SSM Parameter ARN for Master User Name |
| <a name="ssm_paramter_master_password"></a> [ssm_paramter_master_password](#output\_ssm\_paramter\_master\_password) | `string` | The SSM Parameter ARN for Master password |
| <a name="sg_id"></a> [sg_id](#output\_sg\_id) | `string` | The Security Group ID associated to RDS |

## Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-rds-aurora/graphs/contributors).

