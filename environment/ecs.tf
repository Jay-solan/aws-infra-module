module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = var.name

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  autoscaling_capacity_providers = {
    one = {
      auto_scaling_group_arn         = module.asg.autoscaling_group_arn
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 5
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 1
      }

      default_capacity_provider_strategy = {
        weight = 60
        base   = 20
      }
    }
  }

  tags = var.tags
}

module "log_group" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "~> 3.0"

  name              = var.name
  retention_in_days = 120
}

resource "aws_ecs_task_definition" "service" {
  family = "service"
  container_definitions = jsonencode([
    {
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${module.log_group.cloudwatch_log_group_name}",
          "awslogs-region" : "${var.region}",
          "awslogs-stream-prefix" : "ecs"
        }
      },
      "name" : "${var.service_name}",
      "image" : "${var.image}",
      "cpu" : 10,
      "memory" : 512,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : "${var.container_port}",
          "hostPort" : "${var.host_port}"
        }
      ]
    }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  #   placement_constraints {
  #     type       = "memberOf"
  #     expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  #   }
  tags = var.tags
}

resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = var.desired_count
  #   iam_role        = aws_iam_role.foo.arn
  depends_on = [aws_ecs_task_definition.service]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  lifecycle {
    ignore_changes = [desired_count]
  }
  load_balancer {
    target_group_arn = module.alb.target_group_arns[0]
    container_name   = var.service_name
    container_port   = var.container_port
  }
  # default_capacity_provider_strategy = {
  #   weight = 60
  #   base   = 20
  # }
  # propagate_tags = "SERVICE"
  tags           = var.tags
}
