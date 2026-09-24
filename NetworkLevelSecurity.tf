provider "aws" {
    profile = "Company"
    region = "us-east-2"
}

variable "vpc_id" {
    type    = string
    default = "vpc-072ffb22d97e31a68"

}

variable "ami_id" {
    type    = string
    default = "ami-0334938cc69a82b15"
}

variable "internet_gateway_id" {
    type    = string
    default = "igw-0d052c29b3ca8c521"
}

resource "aws_subnet" "new_subnet" {
    vpc_id     = var.vpc_id
    cidr_block = "172.31.100.0/24"
}

resource "aws_route_table" "new_subnet" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.internet_gateway_id
    }
}

resource "aws_route_table_association" "new_subnet" {
    subnet_id       = aws_subnet.new_subnet.id
    route_table_id  = aws_route_table.new_subnet.id
}

resource "aws_security_group" "bastion" {
    name        = "new_bastion-bastion"
    description = "allow RDP to instance from current IP"
    vpc_id      = var.vpc_id
    ingress {
        description = "inbound rds from current IP"
        from_port   = 3389
        to_port     = 3389
        protocol    = "tcp"
        cidr_blocks = ["YOUR_IP/32"]
    }
    egress {
        description = "outbound to internet"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "instance" {
    name = "new_bastion-instance"
    description = "allow RDP to instance from bastion"
    vpc_id      = var.vpc_id
    ingress {
        description = "inbound rds from bastion"
        from_port   = 3389
        to_port     = 3389
        protocol    = "tcp"
        security_groups = [aws_security_group.bastion.id]
    }
    egress {
        description = "outbound to internet"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "bastion" {
    ami = var.ami_id
    instance_type               = "t3.micro"
    subnet_id                   = aws_subnet.new_subnet.id
    vpc_security_group_ids      = [aws_security_group.bastion.id]
    key_name                    = "Company"
    associate_public_ip_address = true
    tags = {
        Name = "Bastion"
    }
}

resource "aws_instance" "instance" {
    ami                     = var.ami_id
    instance_type           = "t3.micro"
    subnet_id               = aws_subnet.new_subnet.id
    vpc_security_group_ids  = [aws_security_group.instance.id]
    key_name                = "Company"
    tags = {
        Name = "Instance"
    }
}


