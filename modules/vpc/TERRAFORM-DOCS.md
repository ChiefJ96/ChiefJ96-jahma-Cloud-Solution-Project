<!-- BEGIN_TF_DOCS -->
# 

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., Development, Production) | `string` | `"Development"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name tag for the VPC | `string` | `"my-vpc"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnet configurations with keys as subnet names | <pre>map(object({<br/>    type              = string          # "public" or "private"<br/>    availability_zone = string<br/>    cidr_block        = string<br/>  }))</pre> | <pre>{<br/>  "dev-db-1a": {<br/>    "availability_zone": "us-west-1a",<br/>    "cidr_block": "10.0.32.0/24",<br/>    "type": "private"<br/>  },<br/>  "dev-db-1b": {<br/>    "availability_zone": "us-west-1b",<br/>    "cidr_block": "10.0.80.0/24",<br/>    "type": "private"<br/>  },<br/>  "dev-private-1a": {<br/>    "availability_zone": "us-west-1a",<br/>    "cidr_block": "10.0.16.0/24",<br/>    "type": "private"<br/>  },<br/>  "dev-private-1b": {<br/>    "availability_zone": "us-west-1b",<br/>    "cidr_block": "10.0.64.0/24",<br/>    "type": "private"<br/>  },<br/>  "dev-public-1a": {<br/>    "availability_zone": "us-west-1a",<br/>    "cidr_block": "10.0.0.0/24",<br/>    "type": "public"<br/>  },<br/>  "dev-public-1b": {<br/>    "availability_zone": "us-west-1b",<br/>    "cidr_block": "10.0.48.0/24",<br/>    "type": "public"<br/>  }<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | Internet Gateway ID |
| <a name="output_private_route_table_id"></a> [private\_route\_table\_id](#output\_private\_route\_table\_id) | Private route table ID |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | IDs of private subnets |
| <a name="output_public_route_table_id"></a> [public\_route\_table\_id](#output\_public\_route\_table\_id) | Public route table ID |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | IDs of public subnets |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
<!-- END_TF_DOCS -->