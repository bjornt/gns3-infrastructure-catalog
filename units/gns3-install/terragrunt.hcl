include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::git@github.com:bjornt/gns3-infrastructure-catalog.git//modules/gns3-install"
}

inputs = {
  gns3_host = values.gns3_host
  sonic_image_path = values.sonic_image_path
}
