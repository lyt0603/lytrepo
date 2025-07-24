provider "aws" {
  region = "ap-northeast-2"
}

variable "vpc_id"{
  default = "vpc-02d43f8b2f868e868"

}

//az1 subnet variable
variable "pa_az1_mgt_subnet_id"{
  default = "subnet-073ef07f9d2a10e92"
}

variable "pa_az1_public_subnet_id"{
  default = "subnet-012436586174cbbaf"
}

variable "pa_az1_private_subnet_id"{
  default = "subnet-08bd7c31964d2a101"
}

//az2 subnet variable
variable "pa_az2_mgt_subnet_id"{
  default = "subnet-066ce348b0ccfb0ca"
}

variable "pa_az2_public_subnet_id"{
  default = "subnet-0d94a40fad096f2a6"
}

variable "pa_az2_private_subnet_id"{
  default = "subnet-0e4292fce1b62c388"
}



//security group
resource "aws_security_group" "allow-mgt-sg" {
  name        = "allow-pa-mgt-sg"
  description = "Allow pa-sg inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "allow-443"
    from_port        = 0
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "allow-22"
    from_port        = 0
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-pa-sg"
  }
}

resource "aws_security_group" "allow-pa-traffic-sg" {
  name        = "allow-pa-traffic-sg"
  description = "Allow pa-sg inbound traffic"
  vpc_id      = "vpc-048f5db31d2361a84"

  ingress {
    description      = "allow-pa-traffic-sg"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-pa-sg"
  }
}


resource "aws_eip" "pa1-mgt" {
  network_interface = aws_network_interface.pa-az1-mgt.id

  tags = {
    Name = "PA1-MGT-EIP"
  }
}

resource "aws_eip" "pa1-untrust" {
  network_interface = aws_network_interface.pa-az1-untrust.id

  tags = {
    Name = "PA1-Untrust-EIP"
  }
}


resource "aws_eip" "pa2-mgt" {
  network_interface = aws_network_interface.pa-az2-mgt.id

  tags = {
    Name = "PA2-MGT-EIP"
  }
}

resource "aws_eip" "pa2-untrust" {
  network_interface = aws_network_interface.pa-az2-untrust.id

  tags = {
    Name = "PA2-Untrust-EIP"
  }
}

//network interface
resource "aws_network_interface" "pa-az1-mgt" {
  subnet_id       = var.pa_az1_mgt_subnet_id
  security_groups = [aws_security_group.allow-mgt-sg.id]

  tags = {
    Name = "PA-AZ1-MGT"
  }
}

resource "aws_network_interface" "pa-az1-untrust" {
  subnet_id       = var.pa_az1_public_subnet_id
  security_groups = [aws_security_group.allow-pa-traffic-sg.id]
  source_dest_check = false

  tags = {
    Name = "PA-AZ1-Untrust"
  }
}

resource "aws_network_interface" "pa-az1-trust" {
  subnet_id       = var.pa_az1_private_subnet_id
  security_groups = [aws_security_group.allow-pa-traffic-sg.id]
  source_dest_check = false


  tags = {
    Name = "PA-AZ1-Trust"
  }

}


resource "aws_network_interface" "pa-az2-mgt" {
  subnet_id       = var.pa_az2_mgt_subnet_id
  security_groups = [aws_security_group.allow-mgt-sg.id]

  tags = {
    Name = "PA-AZ2-MGT"
  }
}

resource "aws_network_interface" "pa-az2-untrust" {
  subnet_id       = var.pa_az2_public_subnet_id
  security_groups = [aws_security_group.allow-pa-traffic-sg.id]
  source_dest_check = false

  tags = {
    Name = "PA-AZ2-Untrust"
  }
}

resource "aws_network_interface" "pa-az2-trust" {
  subnet_id       = var.pa_az2_private_subnet_id
  security_groups = [aws_security_group.allow-pa-traffic-sg.id]
  source_dest_check = false

  tags = {
    Name = "PA-AZ2-Trust"
  }

}




//instance
resource "aws_instance" "az1_paloalto" {
  ami = "ami-090fe8ebee42ad56d"
  instance_type = "m5.xlarge"
  key_name = "lyt_passwd"
  availability_zone = "ap-northeast-2a"
  user_data = "mgmt-interface-swap=enable"

  network_interface {
    network_interface_id = aws_network_interface.pa-az1-mgt.id
    device_index         = 1
  }

  network_interface {
    network_interface_id = aws_network_interface.pa-az1-untrust.id
    device_index         = 0
  }

 network_interface {
    network_interface_id = aws_network_interface.pa-az1-trust.id
    device_index         = 2
  }

  root_block_device {
    volume_size = 60

  }

  tags = {
    Name = "Paloalto_AZ1"
  }


  metadata_options {
    http_tokens = "required"
  }

}

resource "aws_instance" "az2_paloalto" {
  ami = "ami-090fe8ebee42ad56d"
  instance_type = "m5.xlarge"
  key_name = "lyt_passwd"
  availability_zone = "ap-northeast-2b"
  user_data = "mgmt-interface-swap=enable"

    network_interface {
    network_interface_id = aws_network_interface.pa-az2-mgt.id
    device_index         = 1
  }

  network_interface {
    network_interface_id = aws_network_interface.pa-az2-untrust.id
    device_index         = 0
  }

 network_interface {
    network_interface_id = aws_network_interface.pa-az2-trust.id
    device_index         = 2
  }


  root_block_device {
    volume_size = 60

  }

  tags = {
    Name = "Paloalto_AZ2"
  }

  ebs_optimized = true
  monitoring = true
}
