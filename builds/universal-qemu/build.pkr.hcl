build {
  name    = "alse-universal"
  sources = ["source.qemu.alse181-universal"]

  provisioner "shell" {
    inline = [
      "echo Build ${var.distro} ${var.version}",
    ]
  }
}
