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