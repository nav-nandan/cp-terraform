/*
  C3, KC, SR, RP, KSQL, RBAC MDS
*/
resource "aws_security_group" "web" {
    name = "vpc_web"
    description = "Allow incoming HTTP connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.nat.id]
        cidr_blocks = [var.vpc_cidr]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        security_groups = [aws_security_group.nat.id]
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress { # Confluent Control Center
        from_port = 9021
        to_port = 9021
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress { # Kafka Connect
        from_port = 8083
        to_port = 8083
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress { # Schema Registry
        from_port = 8081
        to_port = 8081
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress { # REST Proxy
        from_port = 8082
        to_port = 8082
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress { # KSQL
        from_port = 8088
        to_port = 8088
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress { # RBAC MDS
        from_port = 8090
        to_port = 8090
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress { # Kafka Brokers
        from_port = 9092
        to_port = 9092
        protocol = "tcp"
        cidr_blocks = [var.private_subnet_cidr]
    }
    egress { # Zookeeper
        from_port = 2181
        to_port = 2181
        protocol = "tcp"
        cidr_blocks = [var.private_subnet_cidr]
    }

    vpc_id = aws_vpc.default.id

    tags = {
        Name = "WebServerSG"
    }
}

resource "aws_instance" "web-1" {
    ami = lookup(var.amis, var.aws_region)
    availability_zone = "ap-southeast-1a"
    instance_type = "m5.xlarge"
    key_name = var.aws_key_name
    vpc_security_group_ids = [aws_security_group.web.id]
    subnet_id = aws_subnet.ap-southeast-1a-public.id
    associate_public_ip_address = true
    source_dest_check = false

    tags = {
        Name = "C3"
    }
}

resource "aws_eip" "web-1" {
    instance = aws_instance.web-1.id
    vpc = true
}

resource "aws_instance" "web-2" {
    ami = lookup(var.amis, var.aws_region)
    availability_zone = "ap-southeast-1a"
    instance_type = "m5.xlarge"
    key_name = var.aws_key_name
    vpc_security_group_ids = [aws_security_group.web.id]
    subnet_id = aws_subnet.ap-southeast-1a-public.id
    associate_public_ip_address = true
    source_dest_check = false

    tags = {
        Name = "CP components"
    }
}

resource "aws_eip" "web-2" {
    instance = aws_instance.web-2.id
    vpc = true
}

resource "aws_instance" "web-3" {
    ami = lookup(var.amis, var.aws_region)
    availability_zone = "ap-southeast-1a"
    instance_type = "m5.xlarge"
    key_name = var.aws_key_name
    vpc_security_group_ids = [aws_security_group.web.id]
    subnet_id = aws_subnet.ap-southeast-1a-public.id
    associate_public_ip_address = true
    source_dest_check = false

    tags = {
        Name = "KSQL"
    }
}

resource "aws_eip" "web-3" {
    instance = aws_instance.web-3.id
    vpc = true
}