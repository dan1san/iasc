variable "my_access_key" {
  description = "Access-key-for-AWS"
  default = "no_access_key_value_found"
}
 
variable "my_secret_key" {
  description = "Secret-key-for-AWS"
  default = "no_secret_key_value_found"
}
 
output "access_key_is" {
  value = var.my_access_key
}
 
output "secret_key_is" {
  value = var.my_secret_key
}
 

provider "aws" {
  access_key = var.AWS_ACCESS_KEY
	secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = "us-east-1"
}

resource "aws_instance" "Reverse-Proxy" {
  instance_type = "t2.micro"
  ami           = "ami-08d4ac5b634553e16"

  key_name               = "*Dan1"
  user_data              = filebase64("${path.module}/proyecto/docker.sh")

                                                         
  vpc_security_group_ids = [aws_security_group.WebSG2.id]

  tags = {
    Name = "Proyecto Redes"
  }
}

resource "aws_security_group" "WebSG2" {
  name = "reglas_frirewall2"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SG HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SG HTTPs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SG SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SG ALL Traffic Output"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
#salida de la ip publica.
}
output "public_ip" {

  value = "${join(",", aws_instance.Reverse-Proxy.*.public_ip)}"

}
