# Application Load Balancer Module ⚖️

**What it does:** Distributes incoming traffic across multiple servers with health monitoring.

**Key Features:**
- Internet-facing Application Load Balancer
- Health check monitoring every 30 seconds
- Target groups ready for auto-scaling integration
- Multi-AZ traffic distribution
- SSL/HTTPS ready configuration

## Usage

```hcl
module "application_load_balancer" {
  source = "./modules/alb"
  
  alb_name              = "gogreen-alb"
  vpc_id               = module.vpc.vpc_id
  subnets              = module.vpc.public_subnet_ids
  security_groups      = [module.security_groups.elb_security_group_id]
  target_group_port    = 80
  target_group_protocol = "HTTP"
  health_check_path    = "/health"
  tags                 = var.common_tags
}
```

<!-- BEGIN_TF_DOCS -->
# Application Load Balancer Module ⚖️

**What it does:** Distributes incoming traffic across multiple servers with health monitoring.

**Key Features:**
- Internet-facing Application Load Balancer
- Health check monitoring every 30 seconds
- Target groups ready for auto-scaling integration
- Multi-AZ traffic distribution
- SSL/HTTPS ready configuration

## Usage

```hcl
module "application_load_balancer" {
  source = "./modules/alb"
  
  alb_name              = "gogreen-alb"
  vpc_id               = module.vpc.vpc_id
  subnets              = module.vpc.public_subnet_ids
  security_groups      = [module.security_groups.elb_security_group_id]
  target_group_port    = 80
  target_group_protocol = "HTTP"
  health_check_path    = "/health"
  tags                 = var.common_tags
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | Name of the Application Load Balancer | `string` | n/a | yes |
| <a name="input_health_check_matcher"></a> [health\_check\_matcher](#input\_health\_check\_matcher) | Matcher for health check response | `string` | `"200-399"` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Path for ALB health check | `string` | `"/"` | no |
| <a name="input_listener_port"></a> [listener\_port](#input\_listener\_port) | Listener port on ALB | `number` | `80` | no |
| <a name="input_listener_protocol"></a> [listener\_protocol](#input\_listener\_protocol) | Listener protocol on ALB | `string` | `"HTTP"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security group IDs to attach to ALB | `list(string)` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet IDs for ALB | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_target_group_port"></a> [target\_group\_port](#input\_target\_group\_port) | Port for ALB target group | `number` | `80` | no |
| <a name="input_target_group_protocol"></a> [target\_group\_protocol](#input\_target\_group\_protocol) | Protocol for ALB target group | `string` | `"HTTP"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where ALB and target group will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | ARN of the Application Load Balancer |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | DNS name of the Application Load Balancer |
| <a name="output_listener_arn"></a> [listener\_arn](#output\_listener\_arn) | ARN of the ALB listener |
| <a name="output_target_group_arn"></a> [target\_group\_arn](#output\_target\_group\_arn) | ARN of the ALB target group |

## Resources

| Name | Type |
|------|------|
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
<!-- END_TF_DOCS -->
