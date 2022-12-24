
variable "prefix" {
  default = "dev"
  description = "Prefix for all resources.(default=dev)"
}

variable "region" {
  default = "ap-northeast-1"
  description = "Region for all resources. (default=ap-northeast-1)"
}

variable "az" {
  default = "ap-northeast-1a"
  description = "Availability Zone. (default=ap-northeast-1a)"
}

variable "ami" {
  default = "ami-0bba69335379e17f8"
  description = "AMI ID for dev instance.(default=ami-0bba69335379e17f8)"
}