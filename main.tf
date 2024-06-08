module "root_ec2_instance" {
    source = "./modules/ec2_create"
    instance_type = var.root_instance_type
    allow_ssh = var.root_allow_ssh
    key_name = var.root_key_name
    private_key_download = var.root_private_key_download
}