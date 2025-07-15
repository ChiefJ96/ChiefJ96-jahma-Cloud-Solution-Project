instance_web Module
Deploys EC2 instances for the Web Tier.
Uses the specified AMI, instance type, root volume size.
Encrypts EBS root volumes with a user-provided AWS KMS CMK for data-at-rest security.
Supports tagging and SSH key pair injection for access.
Outputs instance IDs and public IPs for referencing or connecting.