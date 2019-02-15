

variable "security_group_ids" {
  description = "EC2 ssh security group"
  type = "list"
  default = []
}

variable "key_pair_name" {
  description = "EC2 Key pair name"
  default = ""
}

variable "instance_ami" {
  description = "EC2 instance ami"
  default = "ami-0cf31d971a3ca20d6"
}