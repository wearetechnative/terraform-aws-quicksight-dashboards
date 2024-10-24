# Terraform AWS quicksight dashboard ![](https://img.shields.io/github/actions/workflow/status/wearetechnative/terraform-aws-quicksight-dashboard/tflint.yaml?style=plastic)

<!-- SHIELDS -->

This Terraform configuration is designed to deploy AWS QuickSight dashboards by setting up necessary resources and configurations in AWS. The setup ensures that your QuickSight environment is configured correctly for data visualization and reporting.

[![](we-are-technative.png)](https://www.technative.nl)

## How does it work

### First use after you clone this repository or when .pre-commit-config.yaml is updated

Run `pre-commit install` to install any guardrails implemented using pre-commit.

See [pre-commit installation](https://pre-commit.com/#install) on how to install pre-commit.

## Usage
```hcl
provider "aws" {
  profile = "data_collection"
  region  = "eu-central-1"
  alias   = "data_collection"
}

provider "aws" {
  region = "us-east-1"
  alias  = "useast1"
}

module "cid_dashboards" {
  source = "./terraform-aws-quicksight-dashboards/"

  stack_name      = "Cloud-Intelligence-Dashboards"
  stack_parameters = {
    "PrerequisitesQuickSight"            = "yes"
    "PrerequisitesQuickSightPermissions" = "yes"
    "QuickSightUser"                     = "landing_zone_playground/nick@technative.nl" # Change this to your QuickSight user
    "DeployCUDOSDashboard"               = "yes"
    "DeployCostIntelligenceDashboard"    = "yes"
    "DeployKPIDashboard"                 = "yes"
  }

  providers = {
    aws = aws.data_collection
  }
}
```
## Troubleshooting

- **Access Denied Errors**: Ensure that your AWS credentials have sufficient permissions to create and manage QuickSight resources.
- **Resource Conflicts**: Ensure that the names and ARNs provided in the variables do not conflict with existing QuickSight resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.cid](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [aws_s3_bucket.template_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_object.template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [random_id.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_stack_iam_role"></a> [stack\_iam\_role](#input\_stack\_iam\_role) | The ARN of an IAM role that AWS CloudFormation assumes to create the stack (default behavior is to use the previous role if available, or current user permissions otherwise). | `string` | `null` | no |
| <a name="input_stack_name"></a> [stack\_name](#input\_stack\_name) | CloudFormation stack name for Cloud Intelligence Dashboards deployment | `string` | n/a | yes |
| <a name="input_stack_notification_arns"></a> [stack\_notification\_arns](#input\_stack\_notification\_arns) | A list of SNS topic ARNs to publish stack related events. | `list(string)` | `[]` | no |
| <a name="input_stack_parameters"></a> [stack\_parameters](#input\_stack\_parameters) | CloudFormation stack parameters. For the full list of available parameters, refer to<br>https://github.com/aws-samples/aws-cudos-framework-deployment/blob/main/cfn-templates/cid-cfn.yml.<br>For most setups, you will want to set the following parameters:<br>  - PrerequisitesQuickSight: yes/no<br>  - PrerequisitesQuickSightPermissions: yes/no<br>  - QuickSightUser: Existing quicksight user<br>  - QuickSightDataSetRefreshSchedule: Cron expression to refresh spice datasets daily outside of business hours. Default is 4 AM UTC, which should work for most customers in US and EU time zones<br>  - CURBucketPath: Leave as default is if CUR was created with CloudFormation (cur-aggregation.yaml). If it was a manually created CUR, the path entered below must be for the directory that contains the years partition (s3://curbucketname/prefix/curname/curname/).<br>  - OptimizationDataCollectionBucketPath: The S3 path to the bucket created by the Cost Optimization Data Collection Lab. The path will need point to a folder containing /optics-data-collector folder. Required for TAO and Compute Optimizer dashboards.<br>  - DataBuketsKmsKeyArns: Comma-delimited list of KMS key ARNs ("*" is also valid). Include any KMS keys used to encrypt your CUR or Cost Optimization Data S3 data<br>  - DeployCUDOSDashboard: (yes/no, default no)<br>  - DeployCostIntelligenceDashboard: (yes/no, default no)<br>  - DeployKPIDashboard: (yes/no, default no)<br>  - DeployTAODashboard: (yes/no, default no)<br>  - DeployComputeOptimizerDashboard: (yes/no, default no)<br>  - PermissionsBoundary: Leave blank if you don't need to set a boundary for roles<br>  - RolePath: Path for roles where PermissionBoundaries can limit location | `map(string)` | n/a | yes |
| <a name="input_stack_policy_body"></a> [stack\_policy\_body](#input\_stack\_policy\_body) | String containing the stack policy body. Conflicts with stack\_policy\_url. | `string` | `null` | no |
| <a name="input_stack_policy_url"></a> [stack\_policy\_url](#input\_stack\_policy\_url) | Location of a file containing the stack policy body. Conflicts with stack\_policy\_body. | `string` | `null` | no |
| <a name="input_stack_tags"></a> [stack\_tags](#input\_stack\_tags) | Tag key-value pairs to apply to the stack | `map(string)` | `null` | no |
| <a name="input_template_key"></a> [template\_key](#input\_template\_key) | Name of the S3 path/key where the Cloudformation template will be created. Defaults to cid-cfn.yml | `string` | `"cid-cfn.yml"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_stack_outputs"></a> [stack\_outputs](#output\_stack\_outputs) | CloudFormation stack outputs (map of strings) |
<!-- END_TF_DOCS -->
