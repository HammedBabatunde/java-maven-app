variable vpc_cidr_block {
    default = "10.0.0.0/16"
}
variable subnet_cidr_block {
    default = "10.0.0.0/24"
}
variable avail_zone {
    default = "us-east-1a"
}
variable env_prefix {
    default = "dev"
}
variable my_ip {
    default = "102.89.41.203/32"
}
variable "instance_type" {
    default = "t2.micro"
}

variable "jenkins_ip" {
  default =  "54.85.220.25/32"
}

variable "region" {
    default = "us-east-1"
}