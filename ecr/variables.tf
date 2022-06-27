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
variable "ecr_read_write_access_arns" {
  description = "iam role arns for read/write access to repository"
  type        = list(string)
  default     = [""]
}