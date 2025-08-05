terraform {
  required_providers {
    gns3 = {
      source  = "NetOpsChic/gns3"
      version = "2.5.3"
      # source  = "local/bjornt/gns3"
      # version = "2.6.0"
    }
  }
}

provider "gns3" {
  host = "http://${var.gns3_host}:3080"
}
