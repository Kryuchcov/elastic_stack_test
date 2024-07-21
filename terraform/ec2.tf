################################################################################################
# Pems #
################################################################################################

######################## ELASTIC ########################
resource "tls_private_key" "elastic_ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "elastic_ec2_key" {
  key_name   = "elastic_ec2_key"
  public_key = tls_private_key.elastic_ec2_key.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
      echo "${tls_private_key.elastic_ec2_key.private_key_pem}" > elastic_ec2_key.pem
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      chmod 400 elastic_ec2_key.pem
    EOT
  }
}


################################################################################################
# Instances #
################################################################################################

######################## ELASTIC ########################
resource "aws_instance" "elastic_instance" {
  ami                    = var.ec2_settings.elastic_ec2.ami
  instance_type          = var.ec2_settings.elastic_ec2.instance_type
  key_name               = aws_key_pair.elastic_ec2_key.key_name
  vpc_security_group_ids = [aws_security_group.elastic_security_group.id]
  #associate_public_ip_address = true

  root_block_device {
    volume_size = var.ec2_settings.elastic_ec2.root_block_device_volume_size
    volume_type = var.ec2_settings.elastic_ec2.root_block_device_type

    tags = {
      Name = "elastic-main-volume"
    }
  }

  tags = {
    Name = "elastic-ec2"
  }
}

resource "null_resource" "elastic_config" {

  provisioner "remote-exec" {
    inline = ["echo 'Wait unitl ssh is ready'"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.elastic_ec2_key.private_key_pem
      host        = aws_instance.elastic_instance.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ubuntu@${aws_instance.elastic_instance.public_ip}, --private-key ${aws_key_pair.elastic_ec2_key.key_name}.pem ../ansible/elastic_setup.yml "
  }
}