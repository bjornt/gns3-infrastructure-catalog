resource "gns3_project" "project1" {
  name = "sonic-2-racks"
}

data "gns3_template_id" "cloud" {
  name = "Cloud"
}

data "gns3_template_id" "vpcs" {
  name = "VPCS"
}

data "gns3_template_id" "ethernet_switch" {
  name = "Ethernet switch"
}

resource "gns3_template" "mgmt_cloud" {
  template_id = data.gns3_template_id.cloud.id
  name        = "management-cloud"
  project_id  = gns3_project.project1.id
  x           = 500
  y           = 20
}

resource "gns3_template" "mgmt_switch" {
  template_id = data.gns3_template_id.ethernet_switch.id
  name        = "management-switch"
  project_id  = gns3_project.project1.id
  x           = gns3_template.mgmt_cloud.x + 40
  y           = gns3_template.mgmt_cloud.y + 130
}


resource "gns3_template" "mgmt_vpcs1" {
  template_id = data.gns3_template_id.vpcs.id
  name        = "management-vpcs-1"
  project_id  = gns3_project.project1.id
  x           = gns3_template.mgmt_switch.x - 40
  y           = gns3_template.mgmt_switch.y + 150
}


resource "gns3_qemu_node" "core_router" {
  name       = "core-router"
  project_id = gns3_project.project1.id
  # x              = gns3_template.mgmt_switch.x - 80
  # y              = gns3_template.mgmt_switch.y + 150
  adapter_type   = "e1000"
  adapters       = 10
  console_type   = "telnet"
  cpus           = 4
  ram            = 4096
  mac_address    = "52:54:00:5a:00:00"
  platform       = "x86_64"
  hda_disk_image = "sonic-vs-202411.img"
}

resource "gns3_qemu_node" "fabric_switch" {
  name           = "fabric-switch"
  project_id     = gns3_project.project1.id
  adapter_type   = "e1000"
  adapters       = 10
  console_type   = "telnet"
  cpus           = 4
  ram            = 4096
  mac_address    = "52:54:00:5a:20:00"
  platform       = "x86_64"
  hda_disk_image = "sonic-vs-202411.img"
}

resource "gns3_qemu_node" "rack1_data_switch" {
  name           = "rack1-data-switch"
  project_id     = gns3_project.project1.id
  adapter_type   = "e1000"
  adapters       = 10
  console_type   = "telnet"
  cpus           = 4
  ram            = 4096
  mac_address    = "52:54:00:5a:30:00"
  platform       = "x86_64"
  hda_disk_image = "sonic-vs-202411.img"
}

resource "gns3_qemu_node" "rack2_data_switch" {
  name           = "rack2-data-switch"
  project_id     = gns3_project.project1.id
  adapter_type   = "e1000"
  adapters       = 10
  console_type   = "telnet"
  cpus           = 4
  ram            = 4096
  mac_address    = "52:54:00:5a:40:00"
  platform       = "x86_64"
  hda_disk_image = "sonic-vs-202411.img"
}

resource "gns3_link" "mgtm_switch_vpcs1" {
  project_id     = gns3_project.project1.id
  node_a_id      = gns3_template.mgmt_switch.id
  node_a_adapter = 0
  node_a_port    = 1

  node_b_id      = gns3_template.mgmt_vpcs1.id
  node_b_adapter = 0
  node_b_port    = 0
}

resource "gns3_link" "mgtm_switch_core_router" {
  project_id     = gns3_project.project1.id
  node_a_id      = gns3_template.mgmt_switch.id
  node_a_adapter = 0
  node_a_port    = 2

  node_b_id      = gns3_qemu_node.core_router.id
  node_b_adapter = 0
  node_b_port    = 0
}


resource "gns3_link" "cloud_mgtm_switch" {
  project_id     = gns3_project.project1.id
  node_a_id      = gns3_template.mgmt_cloud.id
  node_a_adapter = 0
  node_a_port    = 0

  node_b_id      = gns3_template.mgmt_switch.id
  node_b_adapter = 0
  node_b_port    = 0
}

resource "gns3_link" "mgmt_switch_fabric_switch" {
  project_id     = gns3_project.project1.id
  node_a_id      = gns3_template.mgmt_switch.id
  node_a_adapter = 0
  node_a_port    = 3

  node_b_id      = gns3_qemu_node.fabric_switch.id
  node_b_adapter = 0
  node_b_port    = 0
}

resource "gns3_link" "mgmt_switch_rack1_data_switch" {
  project_id     = gns3_project.project1.id
  node_a_id      = gns3_template.mgmt_switch.id
  node_a_adapter = 0
  node_a_port    = 4

  node_b_id      = gns3_qemu_node.rack1_data_switch.id
  node_b_adapter = 0
  node_b_port    = 0
}

resource "gns3_link" "mgmt_switch_rack2_data_switch" {
  project_id     = gns3_project.project1.id
  node_a_id      = gns3_template.mgmt_switch.id
  node_a_adapter = 0
  node_a_port    = 5

  node_b_id      = gns3_qemu_node.rack2_data_switch.id
  node_b_adapter = 0
  node_b_port    = 0
}

resource "gns3_link" "core_router_fabric_switch" {
  project_id     = gns3_project.project1.id
  node_a_id      = gns3_qemu_node.core_router.id
  node_a_adapter = 2
  node_a_port    = 0

  node_b_id      = gns3_qemu_node.fabric_switch.id
  node_b_adapter = 1
  node_b_port    = 0
}

resource "gns3_link" "fabric_switch_rack1_data_switch" {
  project_id     = gns3_project.project1.id
  node_a_id      = gns3_qemu_node.fabric_switch.id
  node_a_adapter = 3
  node_a_port    = 0

  node_b_id      = gns3_qemu_node.rack1_data_switch.id
  node_b_adapter = 1
  node_b_port    = 0
}

resource "gns3_link" "fabric_switch_rack2_data_switch" {
  project_id     = gns3_project.project1.id
  node_a_id      = gns3_qemu_node.fabric_switch.id
  node_a_adapter = 4
  node_a_port    = 0

  node_b_id      = gns3_qemu_node.rack2_data_switch.id
  node_b_adapter = 1
  node_b_port    = 0
}

resource "gns3_template" "rack1_vpcs1" {
  template_id = data.gns3_template_id.vpcs.id
  name        = "rack1-vpcs-1"
  project_id  = gns3_project.project1.id
  x           = 100 - 100
  y           = 500 + 100
}

resource "gns3_template" "rack1_vpcs2" {
  template_id = data.gns3_template_id.vpcs.id
  name        = "rack1-vpcs-2"
  project_id  = gns3_project.project1.id
  x           = 200 + 100
  y           = 500 + 100
}

resource "gns3_template" "rack2_vpcs1" {
  template_id = data.gns3_template_id.vpcs.id
  name        = "rack2-vpcs-1"
  project_id  = gns3_project.project1.id
  x           = 400 - 100
  y           = 500 + 100
}

resource "gns3_template" "rack2_vpcs2" {
  template_id = data.gns3_template_id.vpcs.id
  name        = "rack2-vpcs-2"
  project_id  = gns3_project.project1.id
  x           = 500 + 100
  y           = 500 + 100
}

resource "gns3_link" "rack1_data_switch_vpcs1" {
  project_id     = gns3_project.project1.id
  node_a_id      = gns3_qemu_node.rack1_data_switch.id
  node_a_adapter = 2
  node_a_port    = 0

  node_b_id      = gns3_template.rack1_vpcs1.id
  node_b_adapter = 0
  node_b_port    = 0
}

resource "gns3_link" "rack1_data_switch_vpcs2" {
  project_id     = gns3_project.project1.id
  node_a_id      = gns3_qemu_node.rack1_data_switch.id
  node_a_adapter = 3
  node_a_port    = 0

  node_b_id      = gns3_template.rack1_vpcs2.id
  node_b_adapter = 0
  node_b_port    = 0
}

resource "gns3_link" "rack2_data_switch_vpcs1" {
  project_id     = gns3_project.project1.id
  node_a_id      = gns3_qemu_node.rack2_data_switch.id
  node_a_adapter = 2
  node_a_port    = 0

  node_b_id      = gns3_template.rack2_vpcs1.id
  node_b_adapter = 0
  node_b_port    = 0
}

resource "gns3_link" "rack2_data_switch_vpcs2" {
  project_id     = gns3_project.project1.id
  node_a_id      = gns3_qemu_node.rack2_data_switch.id
  node_a_adapter = 3
  node_a_port    = 0

  node_b_id      = gns3_template.rack2_vpcs2.id
  node_b_adapter = 0
  node_b_port    = 0
}
