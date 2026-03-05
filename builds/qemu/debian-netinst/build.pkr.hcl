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
  name    = "debian-netinst"
  sources = ["source.qemu.debian-netinst"]

  /*
    Shell provisioner — runs commands inside the VM via SSH.
    Useful for basic setup, debugging, or triggering configuration management.

    - inline: array of commands to execute (one after another)

    Type: provisioner block
    Source: https://www.packer.io/docs/provisioners/shell

  provisioner "shell" {
    inline = [
      "echo Build ${var.distro} ${var.distro_version}",
      "uname -a",
      "id",
    ]
  }
  */

  provisioner "ansible" {
    playbook_file = "${local.distro_dir}/ansible/common.yaml"
    user = var.ssh_login

    extra_arguments = [
      "--extra-vars", "flavor=${var.flavor}",
      "--extra-vars", "features=${jsonencode(var.features)}",
      "-e", "ansible_remote_tmp=/tmp/.ansible/tmp",
      "ANSIBLE_SCP_IF_SSH=True"
    ]
  }
}

