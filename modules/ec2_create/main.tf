data "aws_ami" "ami_data" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
    owners = ["099720109477"]
}

resource "aws_security_group" "allow_ssh" {
    name = var.allow_ssh
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
resource "tls_private_key" "rsa_pem_file" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "rsa_pem_key_create" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_pem_file.public_key_openssh
}
resource "local_file" "private_key_download" {
  content  = tls_private_key.rsa_pem_file.private_key_openssh
  filename = var.private_key_download
}

resource "aws_instance" "ubuntu" {
    ami = data.aws_ami.ami_data.id
    instance_type = var.instance_type
    tags = {
        Name = "TF_inst_practice"
    }
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]
    key_name = aws_key_pair.rsa_pem_key_create.key_name
}