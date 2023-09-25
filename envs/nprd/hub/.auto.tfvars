prefix      = "dbdemo"
environment = "nprd"
regions     = ["eastus", "eastus2", ]
address_spaces = [ "172.20.0.0/20", "172.21.0.0/20", ]
tags        = {
  "owner" = "av"
  "source" = "terraform"
}
