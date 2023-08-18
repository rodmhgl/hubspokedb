module "hub_network" {
  # version     = ""
  source      = "../../../modules/hub"
  environment = var.environment
  prefix      = "dbdemo"
}
