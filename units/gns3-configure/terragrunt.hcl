include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::git@github.com:bjornt/gns3-infrastructure-catalog.git//modules/gns3-configure"
}

dependency "gns3_install" {
  config_path = values.gns3_install_path
}


inputs = {
  gns3_host = dependency.gns3_install.outputs.gns3_host
}
