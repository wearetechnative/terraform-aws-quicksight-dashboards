# Upload the template to the S3 bucket created in main.tf
resource "aws_s3_object" "template" {
  bucket      = aws_s3_bucket.template_bucket.bucket  # Use the bucket from main.tf
  key         = var.template_key
  source      = "${path.module}/cfn-templates/cid-cfn.yml"
  source_hash = filemd5("${path.module}/cfn-templates/cid-cfn.yml")
  tags        = var.stack_tags
}

# Create a CloudFormation stack using the uploaded template
resource "aws_cloudformation_stack" "cid" {
  name         = var.stack_name
  template_url = "https://${aws_s3_bucket.template_bucket.bucket_regional_domain_name}/${aws_s3_object.template.key}?hash=${aws_s3_object.template.source_hash}"  # Reference the bucket created in main.tf
  capabilities = ["CAPABILITY_NAMED_IAM"]
  parameters   = var.stack_parameters
  iam_role_arn = var.stack_iam_role
  policy_body  = var.stack_policy_body
  policy_url   = var.stack_policy_url
  # checkov:skip=CKV_AWS_124:Stack event notifications are configurable by the user
  notification_arns = var.stack_notification_arns
  tags              = var.stack_tags
}
