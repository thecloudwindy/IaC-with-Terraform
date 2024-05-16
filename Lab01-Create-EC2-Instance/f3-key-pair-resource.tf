resource "aws_key_pair" "lab01-sshkey" {
  key_name   = "lab01-sshkey"
  public_key = file("./keypair/lab01-sshkey.pub")
}