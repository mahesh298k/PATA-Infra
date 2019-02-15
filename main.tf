provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
  #profile = "${var.aws_profile}"
}

data "aws_ami" "ec2-ami" {
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Name"
    values = ["HashiPack-Ansible"]
  }

  most_recent = true
}

data "terraform_remote_state" "network" {
  backend = "local"

  config {
    path = "../Network/terraform.tfstate"
  }
}

module "Network" {
  source       = "./Network"
  vpc_cidr     = "${var.vpc_cidr}"
  pub_subnet_cidr = "${var.pub_subnet_cidr}"
  pri_subnet_cidr = "${var.pri_subnet_cidr}"
  #accessip     = "${var.accessip}"
}

module "EC2" {
  source = "./EC2"
  access_key 			= "${var.access_key}"
 	secret_key 			= "${var.secret_key}"
 	region     			= "${var.region}"
 	instance_ami		= "${data.aws_ami.ec2-ami.id}"
 	vpc_id 				= "${data.terraform_remote_state.network.vpc_id}"
	subnet_public_id	= "${data.terraform_remote_state.network.public_subnets[0]}"
	key_pair_name		= "${data.terraform_remote_state.network.ec2keyName}"
	security_group_ids 	= ["${module.Network.sg_ssh}", "${module.Network.sg_http}"]
  
}
