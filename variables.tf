variable "create_global_cluster" {
    description = "Flag to decide if create Aurora global database spread across multiple regions"
    type        = bool
    default     = false
}

variable "global_cluster_name" {
    description = "The Global cluster identifier."
    type        = string
    default     = null
}

#################################################
## Engine options Properties
#################################################
variable "engine" {
    description = "The name of the database engine to be used for this DB cluster."
    type        = string
    default     = "aurora"

    validation {
        condition = contains(["aurora", "aurora-mysql", "aurora-postgresql", "mysql", "postgres"], var.engine)
        error_message = "The valid values for engine are `aurora`, `aurora-mysql`, `aurora-postgresql`, `mysql`, `postgres`." 
    }
}

variable "engine_version" {
    description = "The database engine version."
    type        = string
    default         = null
}

variable "engine_mode" {
    description = "The database engine mode."
    type        = string
    default     = "provisioned"

    validation {
        condition = contains(["global", "multimaster", "parallelquery", "provisioned", "serverless"], var.engine_mode)
        error_message = "The valid values for engine are `global`, `multimaster`, `parallelquery`, `provisioned`, `serverless`." 
    }
}

#################################################
## Cluster Settings Properties
#################################################
variable "create_cluster" {
    description = "Is the cluster Primary?"
    type        = bool
    default     = true
}

variable "primary_cluster" {
    description = "Is the cluster Primary?"
    type        = bool
    default     = true
}

variable "cluster_name" {
    description = "The cluster identifier."
    type        = string
    default     = null
}

variable "master_username" {
    description = "Username for the master DB user."
    type        = string
    default     = "admin"
}

variable "generate_password" {
    description = "Flag to decide if random password should be generated for RDS cluster"
    type        = bool
    default     = true
}

variable "password_length" {
    description = "Length of the password if `generate_password` is set true"
    type        = number
    default     = 8
}

variable "master_password" {
    description = "Password for master DB user. `generate_password will take preference over this property`"
    type        = string
    default     = null
}

variable "enable_global_write_forwarding" {
  description =<<EOF
  Flag to decide if cluster should forward writes to an associated global cluster. 
  Applied to secondary clusters to enable them to forward writes to 
  an `aws_rds_global_cluster`'s primary cluster
  EOF
  type        = bool
  default     = null
}

#################################################
## Instance configuration Properties
#################################################
variable "db_cluster_instance_class" {
    description = "The compute and memory capacity of each DB instance in the Multi-AZ DB cluster"
    type        = string
    default     = null
}

#################################################
## Availability & durability Properties
#################################################
variable "availability_zones" {
    description = <<EOF
List of EC2 Availability Zones for the DB cluster storage where DB cluster instances can be created.
RDS automatically assigns 3 AZs if less than 3 AZs are configured
EOF
    type    = list(string)
    default = null
}

#################################################
## Connectivity Properties
#################################################
variable "db_port" {
    description = "The port on which the DB accepts connections."
    type        = number
    default     = null
}

variable "vpc_id" {
  description   = "The ID of VPC that is used to define the virtual networking environment for this DB cluster."
  type          = string 
  default       = ""
}

variable "create_db_subnet_group" {
    description = "Flag to decide if DB subnet group should be created"
    type        = bool
    default     = true
}

variable "db_subnet_group_name" {
    description = "The name of the subnet group name"
    type        = string
    default     = null
}

variable "subnets" {
    description = "The list of subnet IDs used by database subnet group"
    type        = list(string)
    default     = []
}

variable "additional_sg" {
    description = "(Optional) List of Existing Security Group IDs associated with Database."
    type        = list(string)
    default     = []
}

variable "create_sg" {
    description = "Flag to decide to create Security Group for Database"
    type        = bool
    default     = false
}

variable "sg_name" {
    description = "The name of the Security group"
    type        = string
    default     = ""
}

variable "sg_rules" {
    description = <<EOF

(Optional) Configuration List for Security Group Rules of Security Group:
It is a map of Rule Pairs where,
Key of the map is Rule Type and Value of the map would be an array of Security Rules Map 
There could be 2 Rule Types [Keys] : 'ingress', 'egress'

(Optional) Configuration List of Map for Security Group Rules where each entry will have following properties:

rule_name: (Required) The name of the Rule (Used for terraform perspective to maintain unicity)
description: (Optional) Description of the rule.
from_port: (Required) Start port (or ICMP type number if protocol is "icmp" or "icmpv6").
to_port: (Required) End port (or ICMP code if protocol is "icmp").
protocol: (Required) Protocol. If not icmp, icmpv6, tcp, udp, or all use the protocol number

self: (Optional) Whether the security group itself will be added as a source to this ingress rule. 
cidr_blocks: (Optional) List of IPv4 CIDR blocks
ipv6_cidr_blocks: (Optional) List of IPv6 CIDR blocks.
source_security_group_id: (Optional) Security group id to allow access to/from
 
Note: 
1. `cidr_blocks` Cannot be specified with `source_security_group_id` or `self`.
2. `ipv6_cidr_blocks` Cannot be specified with `source_security_group_id` or `self`.
3. `source_security_group_id` Cannot be specified with `cidr_blocks`, `ipv6_cidr_blocks` or `self`.
4. `self` Cannot be specified with `cidr_blocks`, `ipv6_cidr_blocks` or `source_security_group_id`.

EOF
    default = {}
}

#################################################
## Database authentication Properties
#################################################
variable "iam_database_authentication_enabled" {
    description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
    type        = bool
    default     = null
}

#################################################
## Monitoring Properties
#################################################
variable "enable_enhanced_monitoring" {
    description = "Flag to decide if enhanced monitoring should be enabled"
    type        = bool
    default     = false
}

variable "monitoring_granularity" {
    description = "Monitoring Interval, in seconds"
    type        = number
    default     = 0 # disable

    validation {
        condition = contains([0, 1, 5, 10, 15, 30, 60], var.monitoring_granularity)
        error_message = "Valid values are 0, 1, 5, 10, 15, 30, 60."
    }
}

variable "create_monitoring_role" {
    description = "Flag to decide if IAM role to be created for monitoring"
    type        = bool
    default     = false
}

variable "monitoring_role_name" {
    description = "Flag to decide if enhanced monitoring should be enabled"
    type        = string
    default     = "rds-monitoring-role"
}

#################################################
## Additional configuration Properties
#################################################
variable "database_name" {
    description = "Name for an automatically created database on cluster creation."
    type        = string
}

variable "db_cluster_parameter_group_name" {
    description = "A cluster parameter group to associate with the cluster."
    type        = string
    default     = null
}

variable "db_instance_parameter_group_name" {
    description = "Instance parameter group to associate with all instances of the DB cluster."
    type        = string
    default     = null
}

variable "enable_http_endpoint" {
    description = "Enable HTTP endpoint (data API)"
    type        = bool
    default     = null
}

variable "storage_type" {
    description = "Specifies the storage type to be associated with the DB cluster."
    type        = string
    default     = null

    validation {
        condition = var.storage_type != null ? contains(["io1"], var.storage_type) : true
        error_message = "Valid value for the `storage_type` is `io1`."
    }
}

variable "allocated_storage" {
    description = "The amount of storage in gibibytes (GiB) to allocate to each DB instance in the Multi-AZ DB cluster."
    type        = number
    default     = null
}

variable "iops" {
    description = "The amount of Provisioned IOPS to be initially allocated for each DB instance in the Multi-AZ DB cluster."
    type        = number
    default     = null
}

variable "source_region" {
    description = "The source region for an encrypted replica DB cluster."
    type        = string
    default     = null
}

#################################################
## Backup Properties
#################################################
variable "backup_retention_period" {
    description = "The days to retain backups for."
    type        = number
    default     = 1
}

variable "copy_tags_to_snapshot" {
    description = "Copy all Cluster tags to snapshots."
    type        = bool
    default     = false
}

variable "preferred_backup_window" {
    description = <<EOF
The daily time range (in UTC) during which automated backups are created 
if automated backups are enabled using the backup_retention_period.
EOF
    type    = string
    default = null
}

variable "snapshot_identifier" {
    description = "Specifies whether or not to create this cluster from a snapshot."
    type        = string
    default     = null
}
variable "skip_final_snapshot" {
    description = "Determines whether a final DB snapshot is created before the DB cluster is deleted."
    type        = bool
    default     = false
}

variable "final_snapshot_identifier" {
    description = "The name of your final DB snapshot when this DB cluster is deleted."
    type        = string
    default     = null
}

#################################################
## Encryption Properties
#################################################
variable "storage_encrypted" {
    description = "Specifies whether the DB cluster is encrypted."
    type        = bool
    default     = null
}

variable "kms_key" {
    description = <<EOF
The reference of the KMS key to use.
key Reference could be either of this format:

- 1234abcd-12ab-34cd-56ef-1234567890ab
- arn:aws:kms:<region>:<account no>:key/1234abcd-12ab-34cd-56ef-1234567890ab
- alias/my-key
- arn:aws:kms:<region>:<account no>:alias/my-key
EOF
    type    = string
    default = null
}

#################################################
## Backtrack Properties
#################################################
variable "backtrack_window" {
    description = "The target backtrack window, in seconds."
    type        = number
    default     = 0

    validation {
        condition = var.backtrack_window >= 0 && var.backtrack_window < 259200
        error_message = "The backtrack window must be between 0 and 259200 (72 hours)."
    }
}

#################################################
## Log Exports Properties
#################################################
variable "enabled_cloudwatch_logs_exports" {
    description = "Set of log types to export to cloudwatch."
    type        = set(string)
    default     = []
}

#################################################
## Maintenance Properties
#################################################
variable "allow_major_version_upgrade" {
    description = "Enable to allow major engine version upgrades when changing engine versions."
    type        = bool
    default     = false
}

variable "preferred_maintenance_window" {
    description = "The weekly time range during which system maintenance can occur, in (UTC)."
    type        = string
    default     = null
}

variable "apply_immediately" {
    description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window."
    type        = bool
    default     = false
}

#################################################
## Deletion Protection Properties
#################################################
variable "deletion_protection" {
    description = "If the DB instance should have deletion protection enabled."
    type        = bool
    default     = false
}

#################################################
## Serverless Engine mode Properties
#################################################
variable "scaling_configuration" {
    description = <<EOF
Map of the following Scaling configuirations. Only valid when `engine_mode` is set to `serverless`"

auto_pause: (Optional) Whether to enable automatic pause.
max_capacity: (Optional) The maximum capacity for an Aurora DB cluster in serverless DB engine mode.
min_capacity: (Optional) The minimum capacity for an Aurora DB cluster in serverless DB engine mode.
seconds_until_auto_pause: (Optional) The time, in seconds, before an Aurora DB cluster in serverless mode is paused.
timeout_action: (Optional) The action to take when the timeout is reached.

EOF
    type        = map(string)
    default     = {}
}

#################################################
## Provisioned Engine mode Properties
#################################################
variable "serverlessv2_scaling_configuration" {
    description = <<EOF
Map of the following Scaling configuirations. Only valid when `engine_mode` is set to `serverless`"

max_capacity: (Required) The maximum capacity for an Aurora DB cluster in provisioned DB engine mode.
min_capacity: (Required) The minimum capacity for an Aurora DB cluster in provisioned DB engine mode.

EOF
    type        = map(string)
    default     = {}
}

#################################################
# Cluster Parameter Group Configurations
#################################################

variable "create_db_cluster_parameter_group" {
  description = "Flag to decide if a new cluster parameter group should be created"
  type        = bool
  default     = false
}

variable "db_cluster_parameter_group" {
  description = <<EOF
The name of the DB cluster parameter group

name: (Required) The name of the DB cluster parameter group.
family: (Required) The family of the DB cluster parameter group
description: (Optional) The description of the DB cluster parameter group.
tags: (Optional) A map of tags to assign to the resource.

EOF
  type        = map
  default     = {}
}

variable "db_cluster_parameter_group_parameters" {
  description = <<EOF
A list of DB cluster parameters to apply. Note that parameters may differ from a family to an other

Each map should have the following 3 properties:
name: (Required) The name of the DB parameter.
value: (Required) The value of the DB parameter.
apply_method: (Optional) "immediate" (default), or "pending-reboot".

EOF
  type        = list(map(string))
  default     = []
}

#################################################
# Database Instance Parameter Group Configurations
#################################################

variable "create_db_parameter_group" {
  description = "Flag to decide if a new database instance parameter group should be created"
  type        = bool
  default     = false
}

variable "db_parameter_group" {
  description = <<EOF
The name of the DB instance parameter group

name: (Required) The name of the DB parameter group.
family: (Required) The family of the DB parameter group
description: (Optional) The description of the DB parameter group.
tags: (Optional) A map of tags to assign to the resource.

EOF
  type        = map
  default     = {}
}

variable "db_parameter_group_parameters" {
  description = <<EOF
A list of DB parameters to apply. Note that parameters may differ from a family to an other

Each map should have the following 3 properties:
name: (Required) The name of the DB parameter.
value: (Required) The value of the DB parameter.
apply_method: (Optional) "immediate" (default), or "pending-reboot".

EOF
  type        = list(map(string))
  default     = []
}


#################################################
## Tags
#################################################
variable "default_tags" {
    description = "A map of tags to assign to all the resources."
    type        = map(string)
    default     = {}
}

variable "cluster_tags" {
    description = "A map of tags to assign to the DB cluster."
    type        = map(string)
    default     = {}
}

variable "instance_tags" {
    description = "A map of tags to assign to the DB Instance."
    type        = map(string)
    default     = {}
}

variable "monitoring_role_tags" {
    description = "A map of tags to assign to the Monitoring IAM Role."
    type        = map(string)
    default     = {}
}

#################################################
## SSM Paramteres
#################################################
variable "ssm_parameter_prefix" {
    description = "Prefix for SSM paramteres"
    type = string
    default = ""
}

variable "ssm_cluster_host" {
    description = "Flag to decide if the cluster_host should be stored as SSM parameter"
    type = bool
    default = true
}

variable "ssm_database_name" {
    description = "Flag to decide if the database_name should be stored as SSM parameter"
    type = bool
    default = true
}

variable "ssm_master_username" {
    description = "Flag to decide if the master_username should be stored as SSM parameter"
    type = bool
    default = true
}

variable "ssm_master_password" {
    description = "Flag to decide if the master_password should be stored as SSM parameter"
    type = bool
    default = true
}