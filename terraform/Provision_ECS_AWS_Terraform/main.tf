data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_subnet" "main" {
  count             = var.AZ_Count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  count          = var.AZ_Count
  subnet_id      = element(aws_subnet.main.*.id, count.index)
  route_table_id = aws_route_table.r.id
}

### Compute

resource "aws_autoscaling_group" "app" {
  name                 = var.autoscaling_Group_Name
  vpc_zone_identifier  = aws_subnet.main.*.id
  min_size             = var.autoScaling_Group_Min_Size
  max_size             = var.autoScaling_Group_Max_Size
  desired_capacity     = var.autoScaling_Group_Desired_Capacity
  launch_configuration = aws_launch_configuration.app.name
}

data "template_file" "cloud_config" {
  template = file("${path.module}/cloudconfig.yml")

  vars = {
    aws_region         = var.AWS_Region
    ecs_cluster_name   = aws_ecs_cluster.main.name
    ecs_log_level      = "info"
    ecs_agent_version  = "latest"
    ecs_log_group_name = aws_cloudwatch_log_group.ecs.name
  }
}

data "aws_ami" "Flatcar-stable" {
  most_recent = true

  filter {
    name   = "description"
    values = ["Flatcar Linux stable *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["075585003325"] # CoreOS
}

resource "aws_launch_configuration" "app" {
  security_groups = [
    aws_security_group.instance_sg.id,
  ]

  key_name                    = var.key_Name
  image_id                    = data.aws_ami.Flatcar-stable.id
  instance_type               = var.instance_Type
  iam_instance_profile        = aws_iam_instance_profile.app.name
  user_data                   = data.template_file.cloud_config.rendered
  associate_public_ip_address = true

}

### Security

resource "aws_security_group" "lb_sg" {
  description = "controls access to the application ELB"

  vpc_id = aws_vpc.main.id
  name   = var.LB_Security_Group_Name

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_security_group" "instance_sg" {
  description = "controls direct access to application instances"
  vpc_id      = aws_vpc.main.id
  name        =  var.ECS_Security_Group_Name

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22

    cidr_blocks = [
      var.admin_CIDR_Ingress,
    ]
  }

  ingress {
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080

    security_groups = [
      aws_security_group.lb_sg.id,
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## ECS

resource "aws_ecs_cluster" "main" {
  name = var.ECS_Cluster_Name
}

data "template_file" "task_definition" {
  template = file("${path.module}/task-definition.json")

  vars = {
    image_url        = "ghost:latest"
    container_name   = "ghost"
    log_group_region = var.AWS_Region
    log_group_name   = aws_cloudwatch_log_group.app.name
  }
}
##IAM
resource "aws_ecs_task_definition" "ghost" {
  family                = var.ECS_Task_Definition_Family_Name
  container_definitions = data.template_file.task_definition.rendered
}

resource "aws_ecs_service" "test" {
  name            = var.ECS_Service_Name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.ghost.arn
  desired_count   = 1
  iam_role        = aws_iam_role.ecs_service.name

  load_balancer {
    target_group_arn = aws_alb_target_group.test.id
    container_name   = "ghost"
    container_port   = "2368"
  }

  depends_on = [
    aws_iam_role_policy.ecs_service,
    aws_alb_listener.front_end,
  ]
}

## IAM

resource "aws_iam_role" "ecs_service" {
  name = var.IAM_Role_Name

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_service" {
  name = var.IAM_Role_Policy
  role = aws_iam_role.ecs_service.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "app" {
  name = var.instance_Profile_Name
  role = aws_iam_role.app_instance.name
}

resource "aws_iam_role" "app_instance" {
  name = var.IAM_Role_APP_Instance_Name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "template_file" "instance_profile" {
  template = file("${path.module}/instance-profile-policy.json")

  vars = {
    app_log_group_arn = aws_cloudwatch_log_group.app.arn
    ecs_log_group_arn = aws_cloudwatch_log_group.ecs.arn
  }
}

resource "aws_iam_role_policy" "instance" {
  name   = var.IAM_Role_Instance_Policy
  role   = aws_iam_role.app_instance.name
  policy = data.template_file.instance_profile.rendered
}

## ALB

resource "aws_alb_target_group" "test" {
  name     = var.application_LB_Target_Group_Name
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_alb" "main" {
  name            = var.application_LB_name
  subnets         = aws_subnet.main.*.id
  security_groups = [aws_security_group.lb_sg.id]
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.test.id
    type             = "forward"
  }
}

## CloudWatch Logs

resource "aws_cloudwatch_log_group" "ecs" {
  name = var.ECS_Cloudwatch_Log_Group_Name
}

resource "aws_cloudwatch_log_group" "app" {
  name = var.APP_Cloudwatch_Log_Group_Name
}
