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
        condition = contains(["aurora", "aurora-mysql", "aurora-postgresql"], var.engine)
        error_message = "The valid values for engine are `aurora`, `aurora-mysql`, `aurora-postgresql`." 
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
    description = "Flag to decide if cluster should be provisioned"
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

(Optional) Map of Security Group Rules with 2 Keys ingress and egress.
The value for each key will be a list of Security group rules where 
each entry of the list will again be a map of SG Rule Configuration	
SG Rules Configuration: Refer (https://github.com/arjstack/terraform-aws-security-groups/blob/v1.0.0/README.md#security-group-rule--ingress--egress-)

EOF
    default = {}
}

variable "allowed_sg" {
    description = "List of Source Security Group IDs defined in Ingress of the created SG"
    type        = list(string)
    default     = []
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
## Additional configuration Properties
#################################################
variable "database_name" {
    description = "Name for an automatically created database on cluster creation."
    type        = string
}

variable "enable_http_endpoint" {
    description = "Enable HTTP endpoint (data API)"
    type        = bool
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
    description = "Copy all tags from DB cluster to snapshots."
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
The reference of the KMS key to use for encryption.
key Reference could be either of this format:

- 1234abcd-12ab-34cd-56ef-1234567890ab
- arn:aws:kms:<region>:<account no>:key/1234abcd-12ab-34cd-56ef-1234567890ab
- alias/my-key
- arn:aws:kms:<region>:<account no>:alias/my-key

Note: 
Mandatory to pass it in case of secondary cluster of Global Aurora cluster, 
if `storage_encrypted` is set `true` 
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
    description = "Flag to decide if the DB instance should have deletion protection enabled."
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
The configuration map of the DB cluster parameter group

name: (Required) The name of the DB cluster parameter group.
family: (Required) The family of the DB cluster parameter group
description: (Optional) The description of the DB cluster parameter group.
tags: (Optional) A map of tags to assign to the resource.

EOF
  default     = {}
}

variable "db_cluster_parameter_group_parameters" {
  description = <<EOF
A list of DB cluster parameter group parameters map to apply. Note that parameters may differ from a family to an other

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
The configuration map of the DB instance parameter group

name: (Required) The name of the DB parameter group.
family: (Required) The family of the DB parameter group
description: (Optional) The description of the DB parameter group.
tags: (Optional) A map of tags to assign to the resource.

EOF
  default     = {}
}

variable "db_parameter_group_parameters" {
  description = <<EOF
A list of DB parameters map to apply. Note that parameters may differ from a family to an other

Each map should have the following 3 properties:
name: (Required) The name of the DB parameter.
value: (Required) The value of the DB parameter.
apply_method: (Optional) "immediate" (default), or "pending-reboot".

EOF
  type        = list(map(string))
  default     = []
}

#################################################
## Monitoring properties
#################################################
variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights is enabled or not"
  type        = bool
  default     = false
}

variable "performance_insights_kms_key" {
    description = <<EOF
The reference of the KMS key to encrypt Performance Insights data.
key Reference could be either of this format:

- 1234abcd-12ab-34cd-56ef-1234567890ab
- arn:aws:kms:<region>:<account no>:key/1234abcd-12ab-34cd-56ef-1234567890ab
- alias/my-key
- arn:aws:kms:<region>:<account no>:alias/my-key
EOF
    type        = string
    default     = null
}

variable "performance_insights_retention_period" {
  description = "Amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)"
  type        = number
  default     = 7
}

variable "enable_enhanced_monitoring" {
    description = "Flag to decide if enhanced monitoring should be enabled"
    type        = bool
    default     = false
}

variable "monitoring_granularity" {
    description = "Monitoring Interval, in seconds, to apply on each DB instance"
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
    description = "RDS Monitoring Role Name"
    type        = string
    default     = "rds-monitoring-role"
}

#################################################
## DB Instances
#################################################
variable "instance_class" {
    description = "The compute and memory capacity of each DB instance in the Multi-AZ DB cluster"
    type        = string
    default     = null
}

variable "publicly_accessible" {
    description = "Flag to decide if instances are publicly accessible"
    type        = bool
    default     = false
}

variable "auto_minor_version_upgrade" {
    description = "Enable to allow minor engine upgrades utomatically to the DB instance during the maintenance window."
    type        = bool
    default     = true
}

variable "ca_cert_identifier" {
    description = "The identifier of the CA certificate for the DB instance."
    type        = string
    default     = null 
}

variable "instances" {
    description = <<EOF
List of cluster instances map where each entry of the list may have following attributes for the instance to override

name                    : (Required) The identifier for the RDS instance
instance_class          : (Required) The instance class to use.

availability_zone       : (Optional) The EC2 Availability Zone that the DB instance is created in.
publicly_accessible     : (Optional) Flag to control if instance is publicly accessible.
                          Default - The one set via instances' common property `publicly_accessible`
promotion_tier          : (Optional) Failover Priority setting on instance level.
                          Default - `0`

auto_minor_version_upgrade: (Optional) Enable to allow minor engine upgrades utomatically to the DB instance during the maintenance window.
                            Default - The one set via instances' common property `auto_minor_version_upgrade`
apply_immediately       : (Optional) Specifies whether any database modifications are applied immediately, or during the next maintenance window.
                          Default- the one set at cluster level via property `apply_immediately`

monitoring_granularity  : (Optional) The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. 

preferred_maintenance_window: (Optional) The window to perform maintenance in.
                              Default - The one set at cluster lebel via property `preferred_maintenance_window`
performance_insights_enabled: (Optional) Specifies whether Performance Insights is enabled or not.
                              Default - The one set via instances' common property `performance_insights_enabled`
performance_insights_retention_period: (Optional) Amount of time in days to retain Performance Insights data.
                                       Default - The one set via instances' common property `performance_insights_retention_period`

copy_tags_to_snapshot   : (Optional) Copy all tags from DB instance to snapshots.
                          Default - The one set at cluster lebel via property `copy_tags_to_snapshot`

tags                    : (Optional) A map of tags to assign to the DB Instance.
                          Default - {}
EOF
    default     = []
}

variable "endpoints" {
    description = <<EOF
List of cluster endpoints map where each entry of the list may have following attributes 

identifier      : (Required) The identifier to use for the new endpoint.
type            : (Required) The type of the endpoint. One of: READER, ANY.
static_members  : (Optional) List of DB instance identifiers that are part of the custom endpoint group.
excluded_members: (Optional) List of DB instance identifiers that are not part of the custom endpoint group.
tags            : (Optional) A map of tags to assign to the custom endpoint group. Default - {}

Note: Only one of `static_members` and `excluded_members` can be defined
EOF
    default = []
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
    description = "A map of tags to assign to all the DB Instance."
    type        = map(string)
    default     = {}
}

variable "monitoring_role_tags" {
    description = "A map of tags to assign to the Monitoring IAM Role."
    type        = map(string)
    default     = {}
}
