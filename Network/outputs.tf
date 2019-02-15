
output "co_vpc_id" {
  value = "${aws_vpc.co_vpc.id}"
}

output "co_pub_subnet_id" {
  value = ["${aws_subnet.co_pub_subnet.id}"]
}


output "sg_ssh" {
  value = "${aws_security_group.co_sg_ssh.id}"
}


output "sg_http" {
  value = "${aws_security_group.co_pub_sg.id}"
}