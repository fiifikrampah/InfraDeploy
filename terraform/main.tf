module "network" {
  source    = "./modules/network"
  namespace = var.namespace
}

module "ssh_key" {
  source    = "./modules/ssh_key"
  namespace = var.namespace
}

module "ec2" {
  source     = "./modules/ec2"
  namespace  = var.namespace
  vpc        = module.network.vpc
  sg_pub_id  = module.network.sg_pub_id
  sg_priv_id = module.network.sg_priv_id
  key_name   = module.ssh_key.key_name
}