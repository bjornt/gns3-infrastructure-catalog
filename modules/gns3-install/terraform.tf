terraform {
  required_providers {
    ssh = {
      source  = "loafoe/ssh"
      version = "2.7.0"
    }
    utility = {
      source  = "frontiersgg/utility"
      version = "0.1.0"
    }
  }
}

provider "ssh" {

}
