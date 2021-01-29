# scheduled-container

## AWS Scheduled Container

### Example

Firstly create ECS cluster with strategy FATGATE SPOT

```
data "aws_iam_role" "iam_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_ecs_cluster" "cluster_name" {
  cluster_name = "<<my-cluster-name>>"
}

resource "aws_iam_role_policy_attachment" "iam_for_container-attach" {
  role       = data.aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.policy.arn
}



resource "aws_iam_role_policy" "ecs_events_run_task_with_any_role" {
  name = "ecs_events_run_task_with_any_role"
  role = data.aws_iam_role.iam_role.id

  policy = <<DOC
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "*"
        }
    ]
}
DOC
}

module "crawler-lite" {
  source = "github.com/konradzawadka/scheduled-container"
  name = "<<my-name>"
  image_url = "<<image-url>>"

  cron = "cron(59 11,15,22 * * ? *)"
  cpu = 256
  ram = 512
  environment = [
    {
      name= "ELASTICSEARCH_REGION"
      value= "eu-central-1"
    }
  ]
  command = "my-command"
  subnet_id = "my subnet id eg. subnet-0c61111111111f"
  role_arn = data.aws_iam_role.iam_role.arn
  cluster_arn = data.aws_ecs_cluster.cluster_name.arn
}

```
