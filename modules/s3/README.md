# S3 Storage Module 📦

**What it does:** Secure file storage for GoGreen Insurance documents with KMS encryption.

**Key Features:**
- Military-grade encryption using customer-managed KMS keys
- Bucket policies with least-privilege access
- Versioning enabled for data protection
- Cross-region replication ready

## Usage

```hcl
module "s3_bucket" {
  source = "./modules/s3"
  
  bucket_name         = "gogreen-insurance"
  allowed_principals  = ["arn:aws:iam::123456789012:role/EC2toS3IAMRole"]
  tags               = var.common_tags
}
```

<!-- BEGIN_TF_DOCS -->
# S3 Storage Module 📦

**What it does:** Secure file storage for GoGreen Insurance documents with KMS encryption.

**Key Features:**
- Military-grade encryption using customer-managed KMS keys
- Bucket policies with least-privilege access
- Versioning enabled for data protection
- Cross-region replication ready

## Usage

```hcl
module "s3_bucket" {
  source = "./modules/s3"
  
  bucket_name         = "gogreen-insurance"
  allowed_principals  = ["arn:aws:iam::123456789012:role/EC2toS3IAMRole"]
  tags               = var.common_tags
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_principals"></a> [allowed\_principals](#input\_allowed\_principals) | List of AWS principals allowed to access the bucket | `list(string)` | <pre>[<br/>  "*"<br/>]</pre> | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the S3 bucket | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | ARN of the S3 bucket |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | ID of the S3 bucket |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | ARN of the KMS key used for encryption |

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.s3_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.s3_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.bucket_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
<!-- END_TF_DOCS -->
