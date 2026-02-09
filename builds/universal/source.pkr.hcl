# Basic Base Source ALSE18
source "qemu" "alse18_base" {
  iso_url = "iso/ALSE181.iso"
  iso_checksum = "sha256:auto"
  http_directory = "../http"
  output_directory = "../output/srv"
  disk_size = "150G"
  format = "qcow2"
  accelerator = "kvm"
  ssh_timeout = "20m"
  net_device = "virtio-net"
  disk_interface = "virtio"
  boot_wait = "5s"
}

