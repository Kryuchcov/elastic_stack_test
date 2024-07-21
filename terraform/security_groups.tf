resource "aws_security_group" "elastic_security_group" {
  name        = "elastic-security-group"
  description = "Security group to elastic, also allow config by ssh"

  ingress {
    description = "ssh config"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "elastic port"
    from_port   = "9200"
    to_port     = "9200"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "kibana port"
    from_port   = "5601"
    to_port     = "5601"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "elastic security group"
  }
}