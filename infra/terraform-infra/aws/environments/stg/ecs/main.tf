provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_ecs_cluster" "ecs_cluster" { // Tạo cluster
  name = "ecs-cluster1"
}

resource "aws_security_group" "ecs_security_group" { // Firewall ecs
  name        = "ecs-security-group"
  vpc_id      = data.terraform_remote_state.state_vpc.outputs.public_vpc_id
}

///////////////////////////start task1//////////////////////////////////////////
resource "aws_ecs_task_definition" "my_task1" { // Task 1
  family = "my-task1"
  network_mode = "bridge"
  container_definitions = jsonencode([
    {
      name      = "my-container"
      image     = "nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_alb_target_group" "my_target_group1" { // create target group
  name        = "my-target-group1"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.terraform_remote_state.state_vpc.outputs.public_vpc_id

  health_check {
    path = "/"
    protocol = "HTTP"
    port = "traffic-port"
    matcher = "200"
  }
}

resource "aws_instance" "my_ec2_instance1" { // create ec2
  ami           = "ami-0ac6b9b2908f3e20d"
  instance_type = "t2.micro"
  key_name      = "bastion-dr-apne1"
  subnet_id     = data.terraform_remote_state.state_vpc.outputs.public_subnet_ids[0] 
  
  tags = {
    Name = "ec2-instance1"
  }
}

resource "aws_alb_target_group_attachment" "my_target_group_attachment1" { // add ec2 to target group
  target_group_arn = aws_alb_target_group.my_target_group1.arn
  target_id        = aws_instance.my_ec2_instance1.id
  port             = 80
}

resource "aws_lb" "my_load_balancer1" { // create load blancer
  name               = "my-load-balancer1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_security_group.id]
  subnets            = data.terraform_remote_state.state_vpc.outputs.public_subnet_ids
}

resource "aws_lb_listener" "my_listener1" {
  load_balancer_arn = aws_lb.my_load_balancer1.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.my_target_group1.arn
  }
}

resource "aws_ecs_service" "my_service1" {
  name            = "my-service1"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.my_task1.arn
  desired_count   = 1
  launch_type     = "EC2"

  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 100

  scheduling_strategy = "REPLICA"

  load_balancer {
    target_group_arn = aws_alb_target_group.my_target_group1.arn
    container_name   = "my-container"
    container_port   = 80
  }
}
///////////////////////////end task1//////////////////////////////////////////

///////////////////////////start task2//////////////////////////////////////////
resource "aws_ecs_task_definition" "my_task2" { // Task 2
  family = "my-task2"
  network_mode = "bridge"
  container_definitions = jsonencode([
    {
      name      = "my-container"
      image     = "nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_alb_target_group" "my_target_group2" { // create target group
  name        = "my-target-group2"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.terraform_remote_state.state_vpc.outputs.public_vpc_id

  health_check {
    path = "/"
    protocol = "HTTP"
    port = "traffic-port"
    matcher = "200"
  }
}

resource "aws_instance" "my_ec2_instance2" { // create ec2
  ami           = "ami-0ac6b9b2908f3e20d"
  instance_type = "t2.micro"
  key_name      = "bastion-dr-apne1"
  subnet_id     = data.terraform_remote_state.state_vpc.outputs.public_subnet_ids[0] 
  
  tags = {
    Name = "ec2-instance2"
  }
}

resource "aws_alb_target_group_attachment" "my_target_group_attachment2" { // add ec2 to target group
  target_group_arn = aws_alb_target_group.my_target_group2.arn
  target_id        = aws_instance.my_ec2_instance1.id
  port             = 80
}

resource "aws_lb" "my_load_balancer2" { // create load blancer
  name               = "my-load-balancer2"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_security_group.id]
  subnets            = data.terraform_remote_state.state_vpc.outputs.public_subnet_ids
}

resource "aws_lb_listener" "my_listener2" {
  load_balancer_arn = aws_lb.my_load_balancer2.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.my_target_group2.arn
  }
}

resource "aws_ecs_service" "my_service2" {
  name            = "my-service2"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.my_task2.arn
  desired_count   = 1
  launch_type     = "EC2"

  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 100

  scheduling_strategy = "REPLICA"

  load_balancer {
    target_group_arn = aws_alb_target_group.my_target_group2.arn
    container_name   = "my-container"
    container_port   = 80
  }
}
///////////////////////////end task2//////////////////////////////////////////