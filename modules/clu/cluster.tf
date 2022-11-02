resource "aws_ecr_repository" "awsecr" {
    name = "awsecr120860019576"

    tags = {
        Name = "awsecr120860019576"
    }
}

resource "aws_ecs_cluster" "awsCluster" {
    name = "cluster"

    tags = {
      "Name" = "awsCluster"
    }
}

resource "aws_ecs_task_definition" "awsEcsTaskDefinition" {
    family = "service"
    execution_role_arn = aws_iam_role.iamRoleTreti.arn
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    cpu = "256"
    memory = "512"
    container_definitions = jsonencode([
        {
        name = "first"
        image = "089370973671.dkr.ecr.eu-central-1.amazonaws.com/ecr:latest"
        essential = true
        portMappings = [
            {
                containerPort = 80
                hostPort = 80
            }
        ]
        }
    ])
}

resource "aws_ecs_service" "awsEcsService" {
    name = "ecsService"
    cluster = aws_ecs_cluster.awsCluster.id
    task_definition = aws_ecs_task_definition.awsEcsTaskDefinition.id
    launch_type = "FARGATE"
    scheduling_strategy = "REPLICA"
    desired_count = 1
    force_new_deployment = true
    network_configuration {
        subnets = var.privateSubnet
        assign_public_ip = true
    }
    depends_on = [
      var.listener, var.iamRoleTreti
    ]
}

resource "aws_iam_role" "iamRoleTreti" {
    name = "iamRoleTreti"

    tags = {
      "Name" = "iamRoleTreti"
    }
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid = ""
            Principal = {
                Service = "ecs-tasks.amazonaws.com"
            }
        }]
    })
}