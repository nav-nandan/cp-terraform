/*
  Brokers, Zookeeper
*/
resource "aws_security_group" "kafka" {
    name = "vpc_kafka"
    description = "Allow incoming database connections."

    ingress { # Kafka Clients
        from_port = 9092
        to_port = 9092
        protocol = "tcp"
        security_groups = [aws_security_group.web.id, aws_security_group.nat.id]
        cidr_blocks = [var.private_subnet_cidr]
    }
    ingress { # Zookeeper Clients
        from_port = 2181
        to_port = 2181
        protocol = "tcp"
        security_groups = [aws_security_group.web.id, aws_security_group.nat.id]
        cidr_blocks = [var.private_subnet_cidr]
    }

    ingress { # Inter-broker
        from_port = 9091
        to_port = 9091
        protocol = "tcp"
        cidr_blocks = [var.private_subnet_cidr]
    }
    ingress { # ZK
        from_port = 2888
        to_port = 2888
        protocol = "tcp"
        cidr_blocks = [var.private_subnet_cidr]
    }
    ingress { # ZK
        from_port = 3888
        to_port = 3888
        protocol = "tcp"
        cidr_blocks = [var.private_subnet_cidr]
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
        cidr_blocks = [var.vpc_cidr]
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

    vpc_id = aws_vpc.default.id

    tags = {
        Name = "KafkaClusterSG"
    }
}

resource "aws_instance" "kafka-1" {
    ami = lookup(var.amis, var.aws_region)
    availability_zone = "ap-southeast-1a"
    instance_type = "m5.xlarge"
    key_name = var.aws_key_name
    vpc_security_group_ids = [aws_security_group.kafka.id]
    subnet_id = aws_subnet.ap-southeast-1a-private.id
    source_dest_check = false

    tags = {
        Name = "Kafka Server 1"
    }
}

resource "aws_instance" "kafka-2" {
    ami = lookup(var.amis, var.aws_region)
    availability_zone = "ap-southeast-1a"
    instance_type = "m5.xlarge"
    key_name = var.aws_key_name
    vpc_security_group_ids = [aws_security_group.kafka.id]
    subnet_id = aws_subnet.ap-southeast-1a-private.id
    source_dest_check = false

    tags = {
        Name = "Kafka Server 2"
    }
}

resource "aws_instance" "kafka" {
    ami = lookup(var.amis, var.aws_region)
    availability_zone = "ap-southeast-1a"
    instance_type = "m5.xlarge"
    key_name = var.aws_key_name
    vpc_security_group_ids = [aws_security_group.kafka.id]
    subnet_id = aws_subnet.ap-southeast-1a-private.id
    source_dest_check = false

    tags = {
        Name = "Kafka Server 3"
    }
}