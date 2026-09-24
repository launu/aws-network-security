provider "aws" {
    profile = "Company"
    region = "us-east-2"
}

resource "aws_security_group" "instance" {
    name = "new_sg"
    description = "allow rdp to instance from current IP"
    vpc_id      = "vpc-072ffb64d97e20a62"

    ingress {
        description = "inbound rds from curent ip"
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

resource "aws_instance" "Company" {
    ami = "ami-0b748361ab427e4e6"
    instance_type = "t3.micro"
    subnet_id     = "subnet-08cd011c13b8f214b"
    vpc_security_group_ids = [aws_security_group.instance.id]
    key_name = "Company"
}