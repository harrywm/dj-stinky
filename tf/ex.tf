terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

data "aws_ecs_service" "dj_stinky_service" {
  service_name    = "dj-stinky-service"
  cluster_arn     = "arn:aws:ecs:eu-west-2:818224701131:cluster/dj_stinky_cluster"
}

resource "aws_ecs_task_definition" "stinky_task" {
  family                   = "stinky-task"
  container_definitions    = <<DEFINITION
    [
        {
            "name": "stinky-task",
            "image": "${data.aws_ecr_repository.dj_stinky_repo.repository_url}",
            "essential": true,
            "memory": 1024,
            "cpu": 512,
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "ecs-stinky-task",
                    "awslogs-region": "eu-west-2",
                    "awslogs-stream-prefix": "djstinky" 
                }   
            }  
        }
    ]
    DEFINITION
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    memory                   = 1024
    cpu                      = 512
    execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExcecutionRole_Policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_ecr_repository" "dj_stinky_repo" {
  name = "dj_stinky_repo" #Name of repo
}

resource "aws_ecs_cluster" "dj_stinky_cluster" {
  name = "dj_stinky_cluster"
}

resource "aws_default_vpc" "default_vpc" {
}

resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "eu-west-2a"
}
