variable "dns_ami" {}

resource "aws_instance" "dns_upstream" {
  count                       = 1
  ami                         = "${var.dns_ami}"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["sg-07bac8f0a9b978a39"]
  subnet_id                   = "${var.primary_subnet}"
  associate_public_ip_address = "true"

  tags {
    Name = "dns-upstream"
    vendor = "heptio"
  }
}

