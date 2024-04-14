resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.ami.image_id
  instance_type          = "t2.2xlarge"
  key_name               = var.key-name
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.security-group.id]
  iam_instance_profile   = aws_iam_instance_profile.instance-profile.name
  root_block_device {
    volume_size = 30
  }
  user_data = templatefile("./tools-install.sh", {})

  tags = {
    Name = var.instance-name
  }

  provisioner "file" {
    source      = "create.sh"   # Source path of create.sh
    destination = "/home/ubuntu/script.sh"  # Destination path on EC2 instance
  }

  provisioner "file" {
    source      = "delete.sh"  # Source path of delete.sh
    destination = "/home/ubuntu/delete.sh"  # Destination path on EC2 instance
  }
}
