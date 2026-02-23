/*
  Build block — defines what happens during the image creation process.
  It specifies the source(s) to use and a series of provisioners that
  configure the machine (e.g., shell scripts, file uploads, Ansible, etc.).

  - name:      optional friendly name for the build (appears in logs)
  - sources:   list of source names (from "source" blocks) to build

  Provisioners are executed sequentially after the VM boots and SSH is ready.

  Type: block
  Source: https://www.packer.io/docs/templates/hcl_templates/blocks/build
*/
build {
  name    = "universal-qemu"
  sources = ["source.qemu.universal-qemu"]

  /*
    Shell provisioner — runs commands inside the VM via SSH.
    Useful for basic setup, debugging, or triggering configuration management.

    - inline: array of commands to execute (one after another)

    Type: provisioner block
    Source: https://www.packer.io/docs/provisioners/shell
  */
  provisioner "shell" {
    inline = [
      "echo Build ${var.distro} ${var.version}",
      "uname -a",
      "id",
    ]
  }
}
