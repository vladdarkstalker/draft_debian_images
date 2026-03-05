/*
  VARIABLES OVERVIEW

  project_root    Project root directory
  distro          Linux distribution id (e.g. alse, debian)
  distro_version  Distribution/ISO version (e.g. 1.8.4)
  provider        Build provider (e.g. qemu)
  flavor          Image flavor (e.g. base, arm, srv)
  build_id        Unique build id (local timestamp+git or GitLab pipeline id)

  iso_dir         Base ISO directory (PACKER_ISO_DIR)
  artifacts_dir   Artifacts root directory (PACKER_ARTIFACTS_DIR)

  disk_size       Disk size in GB
  ssh_login       SSH login for provisioning
  ssh_password    SSH password for provisioning
*/

# Project basics

/*
  The root directory of the project. Used as a base for paths.
  This variable must be set, typically via -var or environment.

  Type: string
  Source: https://www.packer.io/docs/templates/hcl_templates/variables
*/
variable "project_root" {
  type        = string
  description = "Project root directory"
  default     = env("PACKER_PROJECT_ROOT")

  validation {
    condition     = var.project_root != ""
    error_message = "The project_root must be set (e.g. -var project_root=/home/packer)!"
  }
}

/**/
variable "comment" {
  type        = string
  description = "Comment for the build"
  default     = ""
}

/**/
variable "build_id" {
  type        = string
  description = "Build ID for the build"

  validation {
    condition     = length(var.build_id) > 0
    error_message = "Build ID must be set (e.g. CI_PIPELINE_ID + CI_COMMIT_SHORT_SHA or CI_PIPELINE_ID-SHA)!"
  }
}

# Build selection

/*
  The Linux distribution to build. Determines which build files are used.
  Allowed values: "alse", "debian", "ubuntu".

  Type: string
  Source: https://www.packer.io/docs/templates/hcl_templates/variables
*/
variable "distro" {
  type        = string
  description = "Linux distribution (e.g. alse, debian)"

  validation {
    condition     = var.distro != ""
    error_message = "The distro must be set (e.g. -var distro=alse)!"
  }

/* TESTING: Need to improve this option
  validation {
    condition     = contains(["alse", "debian", "ubuntu"], var.distro)
    error_message = "The distro must be set (e.g. -var distro=alse)!"
  }
*/
}

/*
  The specific flavor target.
  Examples: "base", "arm", "srv". Must be non‑empty.

  Type: string
  Source: https://www.packer.io/docs/templates/hcl_templates/variables
*/
variable "flavor" {
  type        = string
  description = "Flavor target (e.g. base, arm, srv)"
  default     = "base"

/*
  validation {
    condition     = var.flavor != ""
    error_message = "The flavor must be set (e.g. -var flavor=base)!"
  }
*/
}

/**/
variable "provider" {
  type        = string
  description = "Provider (e.g. qemu, virtualbox)"

  validation {
    condition     = var.provider != ""
    error_message = "The provider must be set (e.g. -var provider=qemu)!"
  }
}

# Directories

/*
  Base directory where ISO files are stored.
  Can be set via the environment variable PACKER_ISO_DIR.

  Type: string
  Source: https://www.packer.io/docs/templates/hcl_templates/variables
*/
variable "iso_dir" {
  type        = string
  description = "Base ISO directory"
  default     = env("PACKER_ISO_DIR")

  validation {
    condition     = var.iso_dir != ""
    error_message = "The iso_dir must be set or provided via PACKER_ISO_DIR!"
  }
}

/*
  The version of the distribution being built.
  Expected format: numeric (e.g., "1.8.1"). Must be non‑empty.

  Type: string
  Source: https://www.packer.io/docs/templates/hcl_templates/variables
*/
variable "distro_version" {
  type        = string
  description = "Distribution version (e.g. 1.8.1)"

  validation {
    condition     = var.distro_version != ""
    error_message = "The distro_version must be set (e.g. -var distro_version=1.8.1)!"
  }

/* TESTING: Need to improve this option
  validation {
    condition     = can(regex("^[0-9]+(\\.[0-9]+)*$", var.distro_version))
    error_message = "distro_version must be numeric, e.g. 181 or 1.8.1"
  }
*/
}

/*
  Directory where build artifacts (e.g., VM images) will be placed.
  Can be set via the environment variable PACKER_ARTIFACTS_DIR.

  Type: string
  Source: https://www.packer.io/docs/templates/hcl_templates/variables
*/
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

/*
  Size of the virtual disk in gigabytes.
  Must be an integer between 20 and 500 GB.

  Type: number
  Source: https://www.packer.io/docs/templates/hcl_templates/variables
*/
variable "disk_size" {
  type        = number
  description = "Disk size in GB"
  default     = 250

  validation {
    condition     = var.disk_size >= 50 && var.disk_size <= 500
    error_message = "The disk_size must be a number between 50 and 500!"
  }
}

# SSH provisioning

/*
  SSH username used to connect to the VM after installation.
  Can be set via the environment variable PACKER_SSH_LOGIN.
  Marked as sensitive to avoid accidental exposure in logs.

  Type: string
  Source: https://www.packer.io/docs/templates/hcl_templates/variables
*/
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

/*
  SSH password used to connect to the VM after installation.
  Can be set via the environment variable PACKER_SSH_PASSWORD.
  Marked as sensitive to avoid accidental exposure in logs.

  Type: string
  Source: https://www.packer.io/docs/templates/hcl_templates/variables
*/
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
