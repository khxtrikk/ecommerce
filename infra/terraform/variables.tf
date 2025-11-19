variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "ssh_public_key" {
  description = "SSH public key content to import into AWS"
  type = string
}

variable "my_ip" {
  description = "Your public IP in CIDR format (e.g. 203.0.113.5/32)"
  type = string
}
