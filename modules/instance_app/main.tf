
resource "aws_instance" "app" {
  count         = var.instance_count
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = merge(var.tags, {
    Name = "web-tier-${count.index + 1}"
  })

  root_block_device {
    volume_size  = var.volume_size
    volume_type  = "gp3"
    encrypted    = true
    kms_key_id   = var.kms_key_id
  }
}