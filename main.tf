terraform {
  backend "s3" {
    bucket         = "my-terraform-tfstates"
    key            = "terraform.tfstate"
    region         = "us-east-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.3"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  #profile = "default"
  region  = "us-east-2"
}


resource "aws_instance" "main_server" {
  ami                    = "ami-0fb653ca2d3203ac1"
  availability_zone = "us-east-2c"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mywebserver.id]


    connection {
      type     = "ssh"
      user     = "ubuntu"
      host = self.public_ip
      private_key = file("C:/Users/алексей/Desktop/alexs.pem")
    } 

    


  key_name = "alexs"
  tags = {
    Name = "main_server"
  }
}

resource "aws_instance" "ansible_sasha" {
  ami                    = "ami-0fb653ca2d3203ac1"
  availability_zone = "us-east-2c"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mywebserver.id]


    connection {
      type     = "ssh"
      user     = "ubuntu"
      host = self.public_ip
      private_key = file("C:/Users/алексей/Desktop/alexs.pem")
    } 

    


  key_name = "alexs"
  tags = {
    Name = "ansible_sasha"
  }
}

resource "aws_instance" "ansible_lesha" {
  ami                    = "ami-0fb653ca2d3203ac1"
  availability_zone = "us-east-2c"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mywebserver.id]


    connection {
      type     = "ssh"
      user     = "ubuntu"
      host = self.public_ip
      private_key = file("C:/Users/алексей/Desktop/alexs.pem")
    } 

    


  key_name = "alexs"
  tags = {
    Name = "ansible_lesha"
  }
}

resource "aws_security_group" "mywebserver" {
  name        = "webserver security group"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]


}

}
output "main_server_ip" {
  value = aws_instance.main_server.public_ip
}

output "ansible_sasha_ip" {
  value = aws_instance.ansible_sasha.public_ip
}

output "ansible_lesha_ip" {
  value = aws_instance.ansible_lesha.public_ip
}
