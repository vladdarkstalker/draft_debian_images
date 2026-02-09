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
    condition     = var.distro != ""
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
