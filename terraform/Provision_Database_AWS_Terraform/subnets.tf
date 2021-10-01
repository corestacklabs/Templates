resource "aws_subnet" "subnet" {

  vpc_id            = "${var.VPC_Id}"
  cidr_block        = "${var.subnet_CIDR}"
  availability_zone = "${var.Availability_Zone_1}"

  tags = {
    Name =  "${var.subnet_Name_1}"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = "${var.VPC_Id}"
  cidr_block        = "${var.subnet1_CIDR}"
  availability_zone = "${var.Availability_Zone_2}"

  tags = {
    Name =  "${var.subnet_Name_2}"
  }
}

