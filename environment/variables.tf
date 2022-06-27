// Common
variable "tags" {
  description = "Tags To b attached to each module"
  type        = map(string)
  default     = {}
}
variable "name" {
  description = "name you wanna give to underlying services"
  type        = string
  default     = ""
}
variable "name6" {
  description = "name you wanna give to underlying services"
  type        = string
  default     = ""
}
variable "region" {
  description = "aws region you wanna create underlying services in"
  type        = string
  default     = ""
}
// VPC
variable "cidr" {
  description = "cidr range for VPC"
  type        = string
  default     = "0.0.0.0/0"
}
variable "azs" {
  description = "Name the Availability Zones for VPC"
  type        = list(string)
  default     = [""]
}
variable "public_subnets" {
  description = "cidr block range for public subnets"
  type        = list(string)
  default     = [""]
}
variable "private_subnets" {
  description = "cidr block range for private subnets"
  type        = list(string)
  default     = [""]
}
// ASG
variable "ami" {
  description = "AMI for instance"
  type        = string
  default     = "ami-0f863d7367abe5d6f"
}
variable "instance_type" {
  description = "Type of instance for auto-scaling group"
  type = string
  default = "t3.micro"
}

// ECS

variable "service_name" {
  description = "name for the service"
  type = string
  default = "service"
}
variable "desired_count" {
  description = "desired count for service"
  type = number
  default = 3
}

variable "image" {
  description = "image for container"
  type = string
  default = ""
}
variable "container_port" {
    description = "port of container"
    type = number
    default = 80
}
variable "host_port" {
    description = "port of host"
    type = number
    default = 80
}