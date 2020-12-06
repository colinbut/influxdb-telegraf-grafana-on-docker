variable "key_name_pair" {
  type        = string
  description = "The name of the Key Pair to ssh into the machine"
}

variable "instance_type" {
  type        = string
  description = "The type of the EC2 instance to create"
  default     = "t2.micro"
}