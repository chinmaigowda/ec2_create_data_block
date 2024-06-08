variable "root_instance_type" {
    type = string
    default = "t2.micro"
}
variable "root_allow_ssh" {
    type = string
    default = "my_security_group_for_ssh"
}
variable "root_key_name" {
    type = string
    default = "tf_key"
}
variable "root_private_key_download" {
    type = string
    default = "./keys/tf_key.pem"
}