resource "aws_security_group" "codebuildSg" {
  name        = "allow_vpc_connectivity"
  description = "Allow Codebuild connectivity to all the resources within our VPC"
  vpc_id      = var.vpcId

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "importCredentials" {

  
  triggers = {
    github_oauth_token = var.token
  }

  provisioner "local-exec" {
    command = <<EOF
      aws --region ${var.region} codebuild import-source-credentials \
                                                             --token ${var.token} \
                                                             --server-type GITHUB \
                                                             --auth-type PERSONAL_ACCESS_TOKEN
EOF
  }
}

resource "aws_iam_role" "iamRoleCodeBuildTreti" {
    name = "iamRoleCodeBuildTreti"

    tags = {
      "Name" = "iamRoleCodeBuildTreti"
    }
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid = ""
            Principal = {
                Service = "codebuild.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role_policy" "rolePolicy" {
  role = aws_iam_role.iamRoleCodeBuildTreti.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
            "ec2:CreateNetworkInterface",
            "ec2:DescribeDhcpOptions",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeVpcs",
            "ssm:GetParameters",
            "logs:PutLogEvents",
            "logs:CreateLogStream",
            "logs:CreateLogGroup",
            "ecr:UploadLayerPart",
            "ecr:PutImage",
            "ecr:InitiateLayerUpload",
            "ecr:GetAuthorizationToken",
            "ecr:CompleteLayerUpload",
            "ecr:BatchCheckLayerAvailability"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource": "arn:aws:ec2:${var.region}:${var.awsacc}:network-interface/*",
      "Condition": {
        "StringEquals": {
          "ec2:AuthorizedService": "codebuild.amazonaws.com"
        },
        "ArnEquals": {
          "ec2:Subnet": [
            "arn:aws:ec2:${var.region}:${var.awsacc}:subnet/*"
          ]
        }
      }
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "duner" {
    depends_on = [null_resource.importCredentials]
    name           = "duner"
    service_role   = aws_iam_role.iamRoleCodeBuildTreti.arn
    build_timeout  = "5"

    artifacts {
        type = "NO_ARTIFACTS"
    }

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/standard:4.0"
        type                        = "LINUX_CONTAINER"
        image_pull_credentials_type = "CODEBUILD"
        privileged_mode             = true

        environment_variable {
            name  = "CI"
            value = "true"
          }
    }

    source {
        type                = "GITHUB"
        location            = "https://github.com/stefobaev/firstDemo.git"
        git_clone_depth     = 1

        git_submodules_config {
          fetch_submodules = true
        }
    }

    vpc_config {
        vpc_id             = var.vpcId
        subnets            = var.privateSubnet
        security_group_ids = [aws_security_group.codebuildSg.id]
    }

    source_version = "main"

    logs_config {
      cloudwatch_logs {
        group_name  = "log-group"
        stream_name = "log-stream"
      }
    }
}