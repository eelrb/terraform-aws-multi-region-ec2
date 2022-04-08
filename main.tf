provider "aws" {
  region = "us-east-1" 
}

provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}


data "aws_ami" "my_image_1" {
  
  most_recent=true
  
  provider = aws

  filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
    }

    filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical

}

data "aws_ami" "my_image_2" {
  
  most_recent=true
  
  provider = aws.us-east-2

  filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
    }

    filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical

}


resource "aws_instance" "blee-ec2" {
  count = "${var.instance_count}"
  ami           = "${data.aws_ami.my_image-1.id}"
  instance_type = "t2.micro"
  #vpc_security_group_ids = ["${aws_security_group.main_sec_group.id}"]
  #subnet_id = "${aws_subnet.subnet1.id}"
  #key_name = "${var.key_name}"
  #tags {
    #Name = "${var.instance_name_vault}"

  #}
  provider = aws
  
}

resource "aws_instance" "blee-ec2-2" {
  count = "${var.instance_count}"
  ami           = "${data.aws_ami.my_image_2.id}"
  instance_type = "t2.micro"
  #vpc_security_group_ids = ["${aws_security_group.main_sec_group.id}"]
  #subnet_id = "${aws_subnet.subnet1.id}"
  #key_name = "${var.key_name}"
  #tags {
    #Name = "${var.instance_name_vault}"

  #}
  provider = aws.us-east-2
}
