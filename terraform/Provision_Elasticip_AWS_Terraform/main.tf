# Specify the provider and access details

data "aws_subnet" "selected" {
  id = "${var.subnet_ID}"
}

resource "aws_network_interface" "foo" {
  subnet_id   = "${var.subnet_ID}"
  
}
resource "aws_eip" "default" {
  instance = "${aws_instance.web.id}"
  vpc      = true
}

# Our default security  to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "${var.security_Group_Name}"
  description = "Used in the terraform from corestack template"
  vpc_id = "${data.aws_subnet.selected.vpc_id}"
  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "web" {
  instance_type = "${var.instance_Type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_AMIS, var.region)}"

  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #
  # https://console.aws.amazon.com/ec2/v2/home?region=us-west-2#KeyPairs:
  #
  key_name = "${var.key_Name}"

  # Our Security group to allow HTTP and SSH access



  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  user_data = "${file("userdata.sh")}"
  
  network_interface {
    network_interface_id = "${aws_network_interface.foo.id}"
    
    device_index = 0

  }
  

  #Instance tags
  tags = {
    Name = "${var.security_Group_Name}"
  } 			
}
