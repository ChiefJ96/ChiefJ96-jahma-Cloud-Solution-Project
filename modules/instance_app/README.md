instance_app Module
Deploys EC2 instances for the Application Tier with configurable AMI and sizing.
Root EBS volumes are encrypted with a specified KMS CMK.
Designed to support mid-range compute workloads handling application logic.
Supports tagging and SSH access with key pairs.
Outputs instance IDs and private IPs.