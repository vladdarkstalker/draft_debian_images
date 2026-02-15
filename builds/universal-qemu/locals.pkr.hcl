/*
        QUICK LOCAL'S REVIEW

project_root     Project root directory
http_dir         Path for provisioning
build_dir        Build target (e.g. astra-arm, debian-srv)
iso_path         Full path to iso distro
artifacts_dir    Artifacts output directory

*/

# Computed paths

locals {

  # Root directories
  project_root = var.project_root
  builds_root  = "${var.project_root}/builds"

  # Build-specific paths
  build_dir = "${local.builds_root}/${var.build}"
  http_dir  = "${local.build_dir}/http"

  # ISO paths
  iso_dir         = var.iso_dir
  distro_iso_dir  = "${var.iso_dir}/${var.distro}"
  iso_filename    = "${var.distro}-${var.version}.iso"
  iso_path        = "${local.distro_iso_dir}/${local.iso_filename}"

  # Artifacts
  artifacts_dir = var.artifacts_dir
}

# Validations with errors

locals {

  _check_build_dir = (can(fileset(local.build_dir, "*"))
    ? true
    : error("Build directory not found: ${local.build_dir}"))

  _check_http_dir = (can(fileset(local.http_dir, "*"))
    ? true
    : error("HTTP directory not found: ${local.http_dir}"))

  _check_iso_dir = (can(fileset(local.iso_dir, "*"))
    ? true
    : error("ISO directory not found: ${local.iso_dir}")
)
  _check_distro_iso_dir = (can(fileset(local.distro_iso_dir, "*"))
    ? true
    : error(join("\n", [
        "ISO distro directory not found: ${local.distro_iso_dir}",
        "Available distro:",
        join("\n", [for file in sort(fileset(local.iso_dir, "*")) : "  • ${file}"])
      ])))

/* TESTING: Enhanced variant
  _check_distro_iso_dir = can(fileset(local.distro_iso_dir, "*"))
    ? true
    : error(join("\n", [
        "Unknown distro: ${var.distro}",
        "Expected directory: ${local.distro_iso_dir}",
        "",
        "Available distros:",
        join("\n", [
          for d in sort(fileset(local.iso_dir, "*")) :
          "  • ${d}"
        ])
      ]))
*/

  _check_iso_path = (fileexists(local.iso_path)
    ? true
    : error(join("\n", [
        "ISO image not found: ${local.iso_path}",
        "Available ISO:",
        join("\n", [for file in sort(fileset(local.distro_iso_dir, "*")) : "  • ${file}"])
      ])))

/* TESTING: Enhanced variant
  _check_iso_path = fileexists(local.iso_path)
    ? true
    : error(join("\n", [
        "ISO image not found:",
        "  ${local.iso_path}",
        "",
        "Available ISO files for distro '${var.distro}':",
        join("\n", [
          for f in sort(fileset(local.distro_iso_dir, "*.iso")) :
          "  • ${f}"
        ])
      ]))
*/

  _check_artifacts_dir = (can(fileset(local.artifacts_dir, "*"))
    ? true
    : error("Artifacts directory not found: ${local.artifacts_dir}"))
}
