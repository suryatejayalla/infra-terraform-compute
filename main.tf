data "aws_vpc" "vpc1" {
  cidr_block       = "10.0.0.0/16"

}

data "aws_subnet" "subnet1" {
  vpc_id     = "${data.aws_vpc.vpc1.id}"
  cidr_block = "10.0.1.0/24"

}


resource "aws_network_interface" "ni" {
  subnet_id   = "${data.aws_subnet.subnet1.id}"
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "ec2" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  key_name      = "ohio"

  network_interface {
    network_interface_id = aws_network_interface.ni.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"

  }

  tags = {
    Name = "coupa-ec2"
  }

}
