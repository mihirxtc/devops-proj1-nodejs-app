provider "aws" { region = "us-east-1" }

# 1. Simple Network (VPC & Subnet)
resource "aws_vpc" "main" { cidr_block = "10.0.0.0/16" }
resource "aws_internet_gateway" "igw" { vpc_id = aws_vpc.main.id }
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# 2. ECS Cluster
resource "aws_ecs_cluster" "main" { name = "node-app-cluster" }

# 3. Task Definition (The instructions for your container)
resource "aws_ecs_task_definition" "app" {
  family                   = "node-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  # ADD THIS LINE BELOW
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name         = "node-app"
    image        = "182335083708.dkr.ecr.us-east-1.amazonaws.com/node-app:latest"
    portMappings = [{ containerPort = 5000, hostPort = 5000 }]
  }])
}

# 4. ECS Service (FARGATE SPOT - Saves 70% cost)
resource "aws_ecs_service" "app" {
  name            = "node-app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
  network_configuration {
    subnets          = [aws_subnet.public.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.allow_node.id]
  }
}

# 5. Security Group (Virtual Firewall)
resource "aws_security_group" "allow_node" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 6. The "Road Map" (Route Table)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# 7. Connect the "Room" to the "Road" (Association)
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# 8 Create the Execution Role so Fargate can pull from ECR
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "node-app-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

# 9. Attach the standard AWS policy for ECR pulling to that role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
