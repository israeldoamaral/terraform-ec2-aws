resource "aws_instance" "ec2" {
  count                       = var.ec2_count
  ami                         = var.ami_id
  associate_public_ip_address = true
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  # security_groups = [var.security_group]
  vpc_security_group_ids      = [var.security_group]
  key_name                    = var.key_name
  user_data = "${file("${var.userdata}")}"

  tags = {
    "Name" = var.tag_name
  }

}
