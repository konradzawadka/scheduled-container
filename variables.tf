variable "name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "image_url" {
  description = "Docker image"
  type        = string
}

variable "command" {
  description = "Docker command"
  type        = string
}

variable "role_arn" {
  description = "Role which will be used in execution"
  type        = string
}


variable "cpu" {
  description = "Number of cpu units min 256"
  type        = number
}


variable "ram" {
  description = "Number mb of ram"
  type        = number
}

variable "cron" {
  description = "cron string in format cron(* * * * * *)"
  type        = string
}

variable "subnet_id" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "cluster_arn" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "repositoryCredentials" {
  description = "The name to use for all the cluster resources"
  type        = object({
      credentialsParameter = string
  })
  default = null
}

variable environment {
  description = "List environment variables"
  type = list(object({
      name = string
      value = string

    }))
}