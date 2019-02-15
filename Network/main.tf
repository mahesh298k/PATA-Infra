resource "aws_vpc" "co_vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
      Name = "co_vpc"
  }
}

resource "aws_internet_gateway" "co_igw" {
    vpc_id = "${aws_vpc.co_vpc.id}"

    tags {
        Name = "co_igw"
    }
}

resource "aws_route_table" "co_pub_rt" {
  vpc_id = "${aws_vpc.co_vpc.id}"

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.co_igw.id}"
  }

  tags {
      Name = "co_pub_rt"
  }
}

resource "aws_default_route_table" "co_pri_rt" {
  default_route_table_id = "${aws_vpc.co_vpc.default_route_table_id}"

  tags {
      Name = "co_pri_rt"
  }
}

resource "aws_subnet" "co_pub_subnet" {
  vpc_id = "${aws_vpc.co_vpc.id}"
  cidr_block = "${var.pub_subnet_cidr}"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
      Name = "co_pub_subnet"
  }
}

resource "aws_subnet" "co_pri_subnet" {
    vpc_id = "${aws_vpc.co_vpc.id}"
    cidr_block = "${var.pri_subnet_cidr}"
    map_public_ip_on_launch = false
    availability_zone = "${data.aws_availability_zones.available.names[1]}"

    tags {
      Name = "co_pri_subnet"
  }
}

resource "aws_route_table_association" "co_pub_assoc" {
    subnet_id = "${aws_subnet.co_pub_subnet.id}"
    route_table_id = "${aws_route_table.co_pub_rt.id}"
}

resource "aws_route_table_association" "co_pri_assoc" {
    subnet_id = "${aws_subnet.co_pri_subnet.id}"
    route_table_id = "${aws_default_route_table.co_pri_rt.id}"
}

resource "aws_security_group" "co_sg_ssh" {
    name = "co_sg_ssh"
    vpc_id = "${aws_vpc.co_vpc.id}"

    #SSH
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "co_pub_sg" {
    name = "co_pub_sg"
    vpc_id = "${aws_vpc.co_vpc.id}"

    #HTTP
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "co_pri_sg" {
    name = "co_pri_sg"
    vpc_id = "${aws_vpc.co_vpc.id}"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}