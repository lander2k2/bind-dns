variable "vpc_id" {}

data "aws_vpc" "existing" {
    id = "${var.vpc_id}"
}

provider "aws" {
    version = "1.14.1"
}

