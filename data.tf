## Data source of KMS Key for DB Cluster Storage
data aws_kms_key "this" {
    count = var.kms_key != null ? 1 : 0

    key_id = var.kms_key
}

## Data source of KMS Key for performance insights 
data aws_kms_key "performance_insights" {
    count = var.performance_insights_kms_key != null ? 1 : 0

    key_id = var.performance_insights_kms_key
}

## Data source for Monitoring IAM role
data aws_iam_role "this" {
    count = (var.enable_enhanced_monitoring && !var.create_monitoring_role) ? 1 : 0
    name = var.monitoring_role_name
}