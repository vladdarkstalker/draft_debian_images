# MAJOR.MINOR.PATCH
locals {
  version = {
    major = 0
    minor = 0
    patch = 0
  }

  image_version = "${local.version.major}.${local.version.minor}.${local.version.patch}"
}
