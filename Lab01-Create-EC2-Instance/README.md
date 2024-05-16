## 1. Tạo SSH Keypair
- Tạo thư mục lưu trữ keypair
    `mkdir keypair`

>
- Command:
`ssh-keygen -t rsa -b 4096 -C "tamng.tng@gmail.com"`
>
- Chọn nơi lưu trữ keypair vừa tạo: `./keypair/lab01-sshkey`
>
## 2. Tạo 1 EC2 Resource, 1 Security Group, 1 Keypair bằng Terraform

#### f1-terraform-version.tf

```c
terraform {
  required_version = "~> 1.7.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
```

#### f2-ec2-instance-resource.tf
```c
resource "aws_instance" "myEC2" {
  ami                    = "ami-0bb84b8ffd87024d8"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  key_name = aws_key_pair.lab01-sshkey.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  tags = {
    "Name" = "myEC2"
  }
}
```

#### f3-key-pair-resource.tf

```c
resource "aws_key_pair" "lab01-sshkey" {
  key_name   = "lab01-sshkey"
  public_key = file("./keypair/lab01-sshkey.pub")
}
```

#### f4-security-group-resource.tf
```c
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_protocol" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_protocol" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_protocol" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
```

