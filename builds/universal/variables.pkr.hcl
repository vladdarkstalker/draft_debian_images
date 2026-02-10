# Project basics

variable "project_root" {
  type        = string
  description = "Project root directory"

  validation {
    condition     = var.project_root != ""
    error_message = "project_root must be set (e.g. -var project_root=/home/packer)"
  }
}

# Build selection

variable "distro" {
  type        = string
  description = "Linux distribution (e.g. alse, debian)"

  validation {
    condition     = contains(["alse", "debian", "ubuntu"], var.distro)
    error_message = "distro must be set (e.g. -var distro=alse)"
  }
}

variable "build" {
  type        = string
  description = "Build target (e.g. astra-arm, debian-srv)"

  validation {
    condition     = var.build != ""
    error_message = "build must be set (e.g. -var build=astra-arm)"
  }
}

variable "version" {
  type        = string
  description = "Distribution version (e.g. 1.8.1)"

  validation {
    condition     = var.version != ""
    error_message = "version must be set (e.g. -var version=1.8.1)"
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
    error_message = "iso_dir must be set or provided via PACKER_ISO_DIR"
  }
}

variable "artifacts_dir" {
  type        = string
  description = "Artifacts output directory"
  default     = env("PACKER_ARTIFACTS_DIR")

  validation {
    condition     = var.artifacts_dir != ""
    error_message = "artifacts_dir must be set or provided via PACKER_ARTIFACTS_DIR"
  }
}

# Disk size in GB

variable disk_size {
  type        = number
  description = "Disk size in GB"

  validation {
    condition = (
      can(tonumber(var.disk_size_gb)) &&
      tonumber(var.disk_size_gb) >= 20 &&
      tonumber(var.disk_size_gb) <= 500
    )
    error_message = "disk_size_gb must be a number between 20 and 500"
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
    error_message = "ssh_login must be set"
  }
}

variable "ssh_password" {
  type        = string
  description = "SSH password for provisioning"
  sensitive   = true
  default     = env("PACKER_SSH_PASSWORD")

  validation {
    condition     = var.ssh_password != ""
    error_message = "ssh_password must be set"
  }
}
