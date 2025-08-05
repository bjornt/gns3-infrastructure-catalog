resource "utility_file_downloader" "gns3_install_script" {
  url      = "https://raw.githubusercontent.com/GNS3/gns3-server/master/scripts/remote-install.sh"
  filename = "${path.module}/gns3-install.sh"
}

resource "ssh_resource" "install_gns3" {
  host  = var.gns3_host
  user  = "ubuntu"
  agent = true

  file {
    source      = utility_file_downloader.gns3_install_script.filename
    destination = "/home/ubuntu/gns3-install.sh"
  }

  commands = [
    "sudo bash /home/ubuntu/gns3-install.sh"
  ]
}

resource "ssh_resource" "upload_sonic_image" {
  depends_on = [
    ssh_resource.install_gns3
  ]

  host  = var.gns3_host
  user  = "ubuntu"
  agent = true

  file {
    source      = var.sonic_image_path
    destination = "/home/ubuntu/${local.sonic_image_name}"
  }

  commands = [
    "md5sum ${local.sonic_image_name} | cut -d ' ' -f 1 -z > ${local.sonic_image_name}.md5sum",
    "sudo mv ${local.sonic_image_name} /opt/gns3/images/QEMU/",
    "sudo mv ${local.sonic_image_name}.md5sum /opt/gns3/images/QEMU/"
  ]
}

locals {
  sonic_image_name = basename(var.sonic_image_path)
}
