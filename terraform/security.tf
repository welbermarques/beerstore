resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.main.id
  name = "hibicode_allow_ssh"

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["${var.my_public_ip}"]
  }
}

resource "aws_security_group" "database" {
  vpc_id = aws_vpc.main.id
  name = "hibicode_database"

  ingress {
    from_port = 5432
    protocol = "tcp"
    to_port = 5432
    self = true
  }
}

resource "aws_security_group" "allow_outbound" {
  vpc_id = aws_vpc.main.id
  name = "hibicode_allow_outbound"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "cluster_communication" {
  vpc_id = aws_vpc.main.id
  name = "hibicode_cluster_communication"

  ingress {
    from_port = 2377
    protocol = "tcp"
    to_port = 2377
    self = true
  }

  ingress {
    from_port = 7946
    protocol = "tcp"
    to_port = 7946
    self = true
  }

  ingress {
    from_port = 7946
    protocol = "udp"
    to_port = 7946
    self = true
  }

  ingress {
    from_port = 4789
    protocol = "udp"
    to_port = 4789
    self = true
  }
}

resource "aws_security_group" "allow_app" {
  vpc_id = aws_vpc.main.id
  name = "hibicode_allow_app"

  ingress {
    from_port = 9000
    protocol = "tcp"
    to_port = 9000
    cidr_blocks = ["${var.my_public_ip}"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = flatten(aws_subnet.public_subnet.*.cidr_block)
  }
}

resource "aws_security_group" "allow_load_balancer" {
  vpc_id = aws_vpc.main.id
  name = "hibicode_allow_loadbalancer"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = flatten(aws_subnet.public_subnet.*.cidr_block)
  }
}