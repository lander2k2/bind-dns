variable "key_name" {}
variable "vpc_id" {}

data "aws_vpc" "existing" {
    id = "${var.vpc_id}"
}

variable "primary_subnet" {}

provider "aws" {
    version = "1.14.1"
}

