# Basic Base Source ALSE18
source "qemu" "alse181-universal" {
  vm_name           = "tdhtest"
  iso_url           = local.iso_path
  iso_checksum      = "none"
  disk_size         = var.disk_size * 1024
  format            = "qcow2"
  accelerator       = "kvm"
  output_directory  = local.artifacts_dir
  shutdown_command  = "echo '${var.ssh_password}' | sudo -S shutdown -P now"
  http_directory    = local.http_dir
  ssh_username      = var.ssh_login
  ssh_password      = var.ssh_password
  ssh_timeout       = "20m"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  boot_wait         = "10s"
  boot_command = [
    "<esc><wait>",
    "auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "<enter>"
  ]
}
