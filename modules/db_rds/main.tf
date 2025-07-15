
// modules/db_rds/main.tf
resource "aws_db_instance" "db" {
  identifier            = var.db_identifier
  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  storage_type          = "io2"                # Provisioned IOPS SSD storage type for consistent high performance
  iops                  = var.iops              # Provisioned IOPS, set to 21000 by default
  storage_encrypted     = true
  kms_key_id            = var.kms_key_id
#   name                  = var.db_name
  username              = var.username
  password              = var.password
  skip_final_snapshot   = var.skip_final_snapshot
  publicly_accessible   = false
  multi_az              = true                  # Enables Multi-AZ high availability deployment

  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name   = var.subnet_group_name

  tags = var.tags
}