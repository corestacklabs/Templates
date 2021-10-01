resource "aws_security_group" "default" {
  name        = "${var.security_Group_Name}"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.VPC_Id}"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "TCP"
    cidr_blocks = ["${var.CIDR_Blocks}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.security_Group_Tag_Name}"
  }
}

