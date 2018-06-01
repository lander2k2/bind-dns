variable "dns_ami" {}

resource "aws_security_group" "dns" {
  name   = "dns"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "TCP"
    cidr_blocks = ["${data.aws_vpc.existing.cidr_block}"]
  }
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "UDP"
    cidr_blocks = ["${data.aws_vpc.existing.cidr_block}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["${data.aws_vpc.existing.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${data.aws_vpc.existing.cidr_block}"]
  }
}

resource "aws_instance" "dns_server" {
  count                       = 2
  ami                         = "${var.dns_ami}"
  instance_type               = "t2.micro"
  subnet_id                   = "${var.primary_subnet}"
  vpc_security_group_ids      = ["${aws_security_group.dns.id}"]
  key_name                    = "${var.key_name}"
  tags {
    Name = "dns"
  }
}

output "dns_server_ip" {
  value = "${aws_instance.dns_server.*.private_ip}"
}

