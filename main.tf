terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.7.4"
    }
  }
}
provider "proxmox" {
    pm_api_url = "https://192.168.0.200:8006/api2/json"
    pm_user = "root@pam"
    pm_password = "123456"
    pm_tls_insecure = "true"
}

resource "proxmox_vm_qemu" "proxmox_vm" {
  count             = 1
  name              = "Ubuntu-terraform-${count.index}"
  target_node       = "mbj"
  clone             = "Ubuntu-template"
  os_type           = "cloud-init"
  cores             = 4
  sockets           = "1"
  cpu               = "host"
  memory            = 2048
  scsihw            = "virtio-scsi-pci"
  boot              = "order=scsi0"

  disk {
    slot = 0
    # set disk size here. leave it small for testing because expanding the disk takes time.
    size = "32G"
    type = "scsi"
    storage = "SSD_STorage"
    iothread = 1
  }
network {
    model           = "virtio"
    bridge          = "vmbr0"
  }
lifecycle {
    ignore_changes  = [
      network,
    ]
  }
}