/*
        QUICK VAR's REVIEW

project_root     Project root directory
distro           Linux distribution (e.g. alse, debian)
build            Build target (e.g. astra-arm, debian-srv)
version          Distribution version (e.g. 1.8.1)
iso_dir          Base ISO directory
artifacts_dir    Artifacts output directory
disk_size        Disk size in GB
ssh_login        SSH login for provisioning
ssh_password     SSH password for provisioning

*/

# Project basics

variable "project_root" {
  type        = string
  description = "Project root directory"

  validation {
    condition     = var.project_root != ""
    error_message = "The project_root must be set (e.g. -var project_root=/home/packer)!"
  }
}

# Build selection

variable "distro" {
  type        = string
  description = "Linux distribution (e.g. alse, debian)"

  validation {
    condition     = contains(["alse", "debian", "ubuntu"], var.distro)
    error_message = "The distro must be set (e.g. -var distro=alse)!"
  }
}

variable "build" {
  type        = string
  description = "Build target (e.g. astra-arm, debian-srv)"

  validation {
    condition     = var.build != ""
    error_message = "The build must be set (e.g. -var build=astra-arm)!"
  }
}

variable "version" {
  type        = string
  description = "Distribution version (e.g. 1.8.1)"

  validation {
    condition     = var.version != ""
    error_message = "The version must be set (e.g. -var version=1.8.1)!"
  }

/* TESTING: Need to improve this option
  validation {
    condition     = can(regex("^[0-9]+(\\.[0-9]+)*$", var.version))
    error_message = "version must be numeric, e.g. 181 or 1.8.1"
  }
*/
}

# Directories

variable "iso_dir" {
  type        = string
  description = "Base ISO directory"
  default     = env("PACKER_ISO_DIR")

  validation {
    condition     = var.iso_dir != ""
    error_message = "The iso_dir must be set or provided via PACKER_ISO_DIR!"
  }
}

variable "artifacts_dir" {
  type        = string
  description = "Artifacts output directory"
  default     = env("PACKER_ARTIFACTS_DIR")

  validation {
    condition     = var.artifacts_dir != ""
    error_message = "The artifacts_dir must be set or provided via PACKER_ARTIFACTS_DIR!"
  }
}

# Disk size in GB

variable disk_size {
  type        = number
  description = "Disk size in GB"

  validation {
    condition     = var.disk_size >= 20 && var.disk_size <= 500
    error_message = "The disk_size must be a number between 20 and 500!"
  }
}

# SSH provisioning

variable "ssh_login" {
  type        = string
  description = "SSH login for provisioning"
  sensitive   = true
  default     = env("PACKER_SSH_LOGIN")

  validation {
    condition     = var.ssh_login != ""
    error_message = "The ssh_login must be set!"
  }
}

variable "ssh_password" {
  type        = string
  description = "SSH password for provisioning"
  sensitive   = true
  default     = env("PACKER_SSH_PASSWORD")

  validation {
    condition     = var.ssh_password != ""
    error_message = "The ssh_password must be set!"
  }
}
