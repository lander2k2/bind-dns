variable "dns_ami" {}

resource "aws_instance" "dns_master" {
  count                       = 1
  ami                         = "${var.dns_ami}"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_name}"

  network_interface = {
    network_interface_id = "${var.master_eni}"
    device_index         = 0
  }

  tags {
    Name = "dns-master"
    vendor = "heptio"
  }
}

resource "aws_instance" "dns_slave" {
  count                       = 1
  ami                         = "${var.dns_ami}"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_name}"

  network_interface = {
    network_interface_id = "${var.slave_eni}"
    device_index         = 0
  }

  tags {
    Name = "dns-slave"
    vendor = "heptio"
  }
}

