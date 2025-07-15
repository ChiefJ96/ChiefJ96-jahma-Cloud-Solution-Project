<!-- BEGIN_TF_DOCS -->
# 

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_application_load_balancer"></a> [application\_load\_balancer](#module\_application\_load\_balancer) | ./modules/alb | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ./modules/iam | n/a |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | ./modules/s3 | n/a |
| <a name="module_security_groups"></a> [security\_groups](#module\_security\_groups) | ./modules/security_group | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [random_id.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy resources | `string` | `"us-west-1"` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Tags to apply to all IAM users and resources | `map(string)` | <pre>{<br/>  "ManagedBy": "Terraform",<br/>  "Project": "GoGreenInsurance"<br/>}</pre> | no |
| <a name="input_ec2_role"></a> [ec2\_role](#input\_ec2\_role) | EC2 IAM role configuration | <pre>object({<br/>    name = string<br/>  })</pre> | <pre>{<br/>  "name": "EC2toS3IAMRole"<br/>}</pre> | no |
| <a name="input_groups"></a> [groups](#input\_groups) | IAM groups configuration with names | <pre>object({<br/>    sysadmin = object({ name = string })<br/>    dbadmin  = object({ name = string })<br/>    monitor  = object({ name = string })<br/>  })</pre> | <pre>{<br/>  "dbadmin": {<br/>    "name": "DBAdmin"<br/>  },<br/>  "monitor": {<br/>    "name": "Monitor"<br/>  },<br/>  "sysadmin": {<br/>    "name": "SysAdmin"<br/>  }<br/>}</pre> | no |
| <a name="input_max_password_age"></a> [max\_password\_age](#input\_max\_password\_age) | Maximum password age in days before reset | `number` | `90` | no |
| <a name="input_minimum_password_length"></a> [minimum\_password\_length](#input\_minimum\_password\_length) | Minimum length for IAM passwords | `number` | `8` | no |
| <a name="input_password_reuse_prevention"></a> [password\_reuse\_prevention](#input\_password\_reuse\_prevention) | Number of previous passwords that cannot be reused | `number` | `3` | no |
| <a name="input_require_lowercase_characters"></a> [require\_lowercase\_characters](#input\_require\_lowercase\_characters) | Require lowercase letters in IAM passwords | `bool` | `true` | no |
| <a name="input_require_numbers"></a> [require\_numbers](#input\_require\_numbers) | Require numbers in IAM passwords | `bool` | `true` | no |
| <a name="input_require_symbols"></a> [require\_symbols](#input\_require\_symbols) | Require special characters in IAM passwords | `bool` | `true` | no |
| <a name="input_require_uppercase_characters"></a> [require\_uppercase\_characters](#input\_require\_uppercase\_characters) | Require uppercase letters in IAM passwords | `bool` | `true` | no |
| <a name="input_users"></a> [users](#input\_users) | Maps of IAM usernames by group | <pre>object({<br/>    sysadmin = map(string)<br/>    dbadmin  = map(string)<br/>    monitor  = map(string)<br/>  })</pre> | <pre>{<br/>  "dbadmin": {<br/>    "dbadmin1": "dbadmin1",<br/>    "dbadmin2": "dbadmin2"<br/>  },<br/>  "monitor": {<br/>    "monitor1": "monitor1",<br/>    "monitor2": "monitor2",<br/>    "monitor3": "monitor3",<br/>    "monitor4": "monitor4"<br/>  },<br/>  "sysadmin": {<br/>    "sysadmin1": "sysadmin1",<br/>    "sysadmin2": "sysadmin2"<br/>  }<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | ALB ARN |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | ALB DNS name for accessing the application |
| <a name="output_dbadmin_users"></a> [dbadmin\_users](#output\_dbadmin\_users) | List of DBAdmin IAM usernames |
| <a name="output_ec2_instance_profile"></a> [ec2\_instance\_profile](#output\_ec2\_instance\_profile) | EC2 instance profile name |
| <a name="output_ec2_role_arn"></a> [ec2\_role\_arn](#output\_ec2\_role\_arn) | ARN of EC2 IAM Role with S3 full access |
| <a name="output_monitor_users"></a> [monitor\_users](#output\_monitor\_users) | List of Monitor IAM usernames |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | Private subnet IDs |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | Public subnet IDs |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | S3 bucket ARN |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | S3 bucket ID |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | Security group IDs |
| <a name="output_sysadmin_users"></a> [sysadmin\_users](#output\_sysadmin\_users) | List of SysAdmin IAM usernames |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
<!-- END_TF_DOCS -->