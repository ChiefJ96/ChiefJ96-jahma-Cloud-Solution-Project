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
| [aws_autoscaling_attachment.my_asg_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_policy.policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_cloudwatch_metric_alarm.reduce_ec2_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_launch_template.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_to_lb"></a> [attach\_to\_lb](#input\_attach\_to\_lb) | n/a | `bool` | `false` | no |
| <a name="input_cloudwatch_alarms"></a> [cloudwatch\_alarms](#input\_cloudwatch\_alarms) | n/a | <pre>map(object({<br/>    name                      = string<br/>    comparison_operator       = string<br/>    evaluation_periods        = number<br/>    metric_name               = string<br/>    period                    = number<br/>    statistic                 = string<br/>    threshold                 = number<br/>    alarm_description         = string<br/>    insufficient_data_actions = optional(list(string))<br/>    policy_to_use             = string<br/>  }))</pre> | n/a | yes |
| <a name="input_launch_template"></a> [launch\_template](#input\_launch\_template) | n/a | <pre>object({<br/>    ami                 = string<br/>    prefix              = string<br/>    instance_class      = string<br/>    description         = optional(string)<br/>    detailed_monitoring = optional(bool, false)<br/>    key_name            = optional(string)<br/>    security_group_id   = optional(string)<br/>    user_data           = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_scaling_group"></a> [scaling\_group](#input\_scaling\_group) | n/a | <pre>object({<br/>    subnet_ids       = optional(list(string))<br/>    desired_capacity = number<br/>    max_size         = number<br/>    min_size         = number<br/>  })</pre> | n/a | yes |
| <a name="input_scaling_policies"></a> [scaling\_policies](#input\_scaling\_policies) | n/a | <pre>map(object({<br/>    name               = string<br/>    scaling_adjustment = number<br/>    adjustment_type    = string<br/>    cooldown           = number<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_target_group_arn"></a> [target\_group\_arn](#input\_target\_group\_arn) | ARN of the target group to attach the auto scaling group to | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->