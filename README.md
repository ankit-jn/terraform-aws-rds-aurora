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
| <a name="master_username"></a> [master_username](#input\_master_username) | Username for the master DB user. | `string` | `"admin"` | no |  |

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

