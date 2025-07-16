
#############################
# IAM Account Password Policy
#############################

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = var.minimum_password_length
  require_uppercase_characters   = var.require_uppercase_characters
  require_lowercase_characters   = var.require_lowercase_characters
  require_symbols                = var.require_symbols
  require_numbers                = var.require_numbers
  allow_users_to_change_password = true
  max_password_age               = var.max_password_age
  password_reuse_prevention      = var.password_reuse_prevention
  hard_expiry                   = false
}

#############################
# IAM Groups
#############################

resource "aws_iam_group" "sysadmin" {
  name = var.groups.sysadmin.name
}

resource "aws_iam_group" "dbadmin" {
  name = var.groups.dbadmin.name
}

resource "aws_iam_group" "monitor" {
  name = var.groups.monitor.name
}

#############################
# IAM Users
#############################

resource "aws_iam_user" "sysadmin_users" {
  for_each = var.users.sysadmin
  name     = each.value

  tags = merge(var.common_tags, { Role = "SysAdmin" })
}

resource "aws_iam_user_group_membership" "sysadmin_memberships" {
  for_each = aws_iam_user.sysadmin_users

  user   = each.value.name
  groups = [aws_iam_group.sysadmin.name]
}

resource "aws_iam_user" "dbadmin_users" {

  for_each = var.users.dbadmin
  name     = each.value

  tags = merge(var.common_tags, { Role = "DBAdmin" })
}

resource "aws_iam_user_group_membership" "dbadmin_memberships" {
  for_each = aws_iam_user.dbadmin_users

  user   = each.value.name
  groups = [aws_iam_group.dbadmin.name]
}

resource "aws_iam_user" "monitor_users" {
  # FIXED: Changed from toset() to direct map usage since var.users.monitor is a map(string)
  for_each = var.users.monitor
  name     = each.value

  tags = merge(var.common_tags, { Role = "Monitor" })
}

resource "aws_iam_user_group_membership" "monitor_memberships" {
  for_each = aws_iam_user.monitor_users

  user   = each.value.name
  groups = [aws_iam_group.monitor.name]
}

#############################
# IAM Group Policy Attachments
#############################

resource "aws_iam_group_policy_attachment" "sysadmin_policy_attachment" {
  group      = aws_iam_group.sysadmin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "dbadmin_policy_attachment" {
  group      = aws_iam_group.dbadmin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_group_policy_attachment" "monitor_s3_policy_attachment" {
  group      = aws_iam_group.monitor.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "monitor_ec2_policy_attachment" {
  group      = aws_iam_group.monitor.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "monitor_rds_policy_attachment" {
  group      = aws_iam_group.monitor.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess"
}

#############################
# EC2 IAM Role with S3 Full Access
#############################

resource "aws_iam_role" "ec2s3_role" {
  name = var.ec2_role.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2s3_role_policy_attach" {
  role       = aws_iam_role.ec2s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "ec2s3_instance_profile" {
  name = "${var.ec2_role.name}-instance-profile"
  role = aws_iam_role.ec2s3_role.name
}