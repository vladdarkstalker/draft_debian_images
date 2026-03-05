# Basic Base Source
source "qemu" "universal" {

/*
  This is the name of the image (QCOW2 or IMG) file for the new virtual machine.

  Type: string
  Source: https://www.packer.io/plugins/builders/qemu
*/
  vm_name = local.artifact_name

/*
  A URL to the ISO containing the installation image or virtual hard drive (VHD or VHDX) file to clone.

  Type: string
  Source: https://www.packer.io/plugins/builders/qemu
*/
  iso_url = local.iso_path

/*
  The checksum for the ISO file. Used to verify the integrity of the downloaded file.
  The value can be "none" to skip checksumming, or a string like "md5:..." or "sha256:...".

  Type: string
  Source: https://www.packer.io/plugins/builders/qemu
*/
  iso_checksum = "none"

/*
  The size of the virtual disk in megabytes.

  Type: int (megabytes)
  Source: https://www.packer.io/plugins/builders/qemu
*/
  disk_size = var.disk_size * 1024

/*
  The amount of memory to use for the VM in megabytes.

  Type: int (megabytes)
  Source: https://www.packer.io/plugins/builders/qemu
*/
  memory = 8192

/*
  The number of CPUs to use for the VM.

  Type: int
  Source: https://www.packer.io/plugins/builders/qemu
*/
  cpus = 4

/*
  The format of the output image. 
  Supported values are "qcow2" (default) and "raw".

  Type: string
  Source: https://www.packer.io/plugins/builders/qemu
*/
  format = "qcow2"

/*
  The type of disk interface to use. 
  Common values are "ide", "sata", "scsi", "virtio" (default), and "virtio-scsi".

  Type: string
  Source: https://www.packer.io/plugins/builders/qemu
*/
  disk_interface = "virtio"

/*
  The model of the network device to emulate. 
  Common values are "virtio-net" (default), "e1000", and "rtl8139".

  Type: string
  Source: https://www.packer.io/plugins/builders/qemu
*/
  net_device = "virtio-net"

/*
  The type of hardware acceleration to use.
  Supported values:
    "none" - Disable acceleration, pure emulation.
    "kvm"  - Use KVM (Linux).
    "tcg"  - Tiny Code Generator (software emulation).
    "hax"  - Intel HAXM (Windows/macOS, deprecated as of QEMU 8.0).
    "hvf"  - Hypervisor.framework (macOS).
    "whpx" - Windows Hypervisor Platform.
    "xen"  - Use Xen hypervisor.
  
  If not specified, Packer tries "kvm" first, then falls back to "tcg".

  Type: string
  Source: https://www.packer.io/plugins/builders/qemu
*/
# accelerator = "kvm"

/*
  The directory where the final VM image will be stored.

  Type: string
  Source: https://www.packer.io/plugins/builders/qemu
*/
  output_directory = "${local.artifacts_dir}/${var.distro}-${var.distro_version}"

/*
  The directory from which files will be served by Packer's internal HTTP server.
  Files placed here can be accessed during the build via http://{{.HTTPIP}}:{{.HTTPPort}}/filename.

  Type: string
  Source: https://www.packer.io/plugins/builders/qemu
*/
  http_directory = local.http_dir

/*
  The time to wait after the VM starts before sending boot commands.
  Example: "3s" (3 seconds), "1m30s".

  Type: string (duration)
  Source: https://www.packer.io/plugins/builders/qemu
*/
  boot_wait = "3s"

/*
  Additional arguments to pass to QEMU. 
  This allows fine‑grained control over the QEMU command line.
  Each inner array represents a single argument (or a flag and its value).

  Type: list(list(string))
  Source: https://www.packer.io/plugins/builders/qemu
*/
  qemuargs = []

/*
  A list of keystrokes to send to the VM to control the OS installer.
  Special keys are enclosed in angle brackets, e.g., <enter>, <wait>, <down>, <f10>.
  The variables {{ .HTTPIP }} and {{ .HTTPPort }} are replaced with the address
  of Packer's HTTP server, allowing you to fetch files hosted via http_directory.

  The exact sequence depends on the bootloader and installer of the target OS.
  Typically, you may need to interrupt the boot process (e.g., by pressing a key),
  edit the kernel command line, and add parameters for automated installation.
  The example below illustrates a generic workflow:

    1. Hold Shift (or another key) to enter the boot menu.
    2. Press 'e' to edit the kernel command line.
    3. Navigate to the end of the line.
    4. Append kernel parameters, including the URL to the preseed file
       served by Packer: http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg
    5. Press F10 to boot.

  The variables are automatically replaced with the actual IP and port of the
  running HTTP server (e.g., http://10.0.2.2:8080/preseed.cfg).

  Type: list(string)
  Source: https://www.packer.io/plugins/builders/qemu#boot_command
*/
  boot_command = []

/*
  The username used to connect to the VM via SSH after the OS is installed.

  Type: string
  Source: https://www.packer.io/plugins/builders/qemu
*/
  ssh_username = var.ssh_login

/*
  The password used for the SSH connection.

  Type: string
  Source: https://www.packer.io/plugins/builders/qemu
*/
  ssh_password = var.ssh_password

/*
  The command to run to shut down the VM after provisioning is complete.
  This command is executed over SSH.

  Type: string
  Source: https://www.packer.io/plugins/builders/qemu
*/
  shutdown_command = "echo '${var.ssh_password}' | sudo -S -p '' /sbin/shutdown -P now"

/*
  The maximum time to wait for SSH to become available.
  Example: "20m" (20 minutes).

  Type: string (duration)
  Source: https://www.packer.io/plugins/builders/qemu
*/
  ssh_timeout = "30m"
}
