variable "security_Group_Name"{
  description = "The name for the security group to create"
}

variable "subnet_ID"{
  description = "The ID for the existing subnet"
}


variable "region" {
  description = "The AWS region to create things in."
  default = "us-east-1"

}

# ubuntu-trusty-14.04 (x64)
variable "aws_AMIS" {
default = {
    "us-west-2" = "ami-6f523217"
    "us-west-1" = "ami-0ad16744583f21877"
    "us-east-2" = "ami-0653e888ec96eab9b"
    "us-east-1" = "ami-059eeca93cf09eebd"
    "ap-south-1" = "ami-04ea996e7a3e7ad6b"
    "ap-northeast-2" = "ami-0e0f4ff1154834540"
    "ap-southeast-1" = "ami-0eb1f21bbd66347fe"
    "ap-southeast-2" = "ami-0789a5fb42dcccc10"
    "ca-central-1" = "ami-0f2cb2729acf8f494"
    "eu-central-1" ="ami-086a09d5b9fa35dc7"
    "eu-west-1" = "ami-09f0b8b3e41191524"
    "eu-west-2" = "ami-061a2d878e5754b62"
    "eu-west-3" = "ami-075b44448d2276521"
    "sa-east-1" = "ami-0318cb6e2f90d688b"
    "ap-northeast-1" = "ami-06c43a7df16e8213c"
  
}
}

variable "key_Name" {
  description = "Name of the existing SSH keypair to use in AWS."
}

variable "instance_Type" {
  description = "The instance type."
  default = "t2.micro"
}
