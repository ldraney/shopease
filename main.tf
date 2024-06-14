provider "aws" {
  region = "us-west-2" # Adjust the region as needed
}

resource "aws_ecs_task_definition" "shopease_task" {
  family                   = "shopease"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "1GB"

  container_definitions = jsonencode([
    {
      name          = "shopease-web"
      image         = "tomcat:jdk8-adoptopenjdk-openj9"
      memory        = 500
      logConfiguration = {
        logDriver = "awsfirelens"
        options = {
          Name        = "datadog"
          apikey      = "<DATADOG_API_KEY>"
          Host        = "http-intake.logs.datadoghq.com"
          dd_service  = "shopease-web-service"
          dd_source   = "shopease-web-source"
          TLS         = "on"
          provider    = "ecs"
        }
      }
    },
    {
      name                = "shopease-log_router"
      image               = "amazon/aws-for-fluent-bit:stable"
      essential           = true
      memoryReservation   = 50
      firelensConfiguration = {
        type    = "fluentbit"
        options = {
          enable-ecs-log-metadata = true
        }
      }
    }
  ])
}
