/*
  Packer block — used to configure Packer itself, especially to declare
  required plugins and their versions. This ensures that the correct
  plugins are installed before the build starts.

  - required_plugins: map of plugin names to version constraints and sources

  Type: block
  Source: https://www.packer.io/docs/templates/hcl_templates/blocks/packer
*/
packer {
  required_plugins {
    /*
      QEMU plugin — enables building VM images using QEMU.
      Version constraint ">= 1.0.0" ensures a recent version is used.
      The source is the official HashiCorp QEMU plugin on GitHub.

      Type: plugin requirement
      Source: https://github.com/hashicorp/packer-plugin-qemu
    */
    qemu = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}
