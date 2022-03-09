# variable "ec2_count" {
#   default = "1"
# }

variable "ami_id" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "subnet_id" {}

variable "security_group" {
  type = string
}

variable "key_name" {

}

variable "userdata" {}

variable "tag_name" {}
