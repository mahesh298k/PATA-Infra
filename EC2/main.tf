resource "aws_instance" "co_nginx" {
    ami = "${var.pack_ami}"
    instance_type = "${var.instance_capacity}"
    subnet_id = "${var.co_pub_subnet_id}"
    vpc_security_group_ids = ["${var.security_group_ids}"]
    key_name = "${var.key_pair_name}"

     tags {
		"Name" = "Test-Instance-1"
	}
}