/*
  QUICK LOCAL's REVIEW

  project_root   Project root directory
  http_dir       Path for provisioning files (served by Packer HTTP)
  build_dir      Build target directory (e.g., astra-arm, debian-srv)
  iso_path       Full path to the distribution ISO
  artifacts_dir  Artifacts output directory
*/

# Computed paths

locals {

  /*
    The root directory of the project. Passed through from var.project_root.

    Type: string
    Source: https://www.packer.io/docs/templates/hcl_templates/locals
  */
  project_root = var.project_root

  /*
    The base directory containing all build definitions.
    Constructed as <project_root>/builds.

    Type: string
    Source: https://www.packer.io/docs/templates/hcl_templates/locals
  */
  builds_root = "${var.project_root}/builds"

  /*
    The directory specific to the current build target.
    Constructed as <builds_root>/<var.build>.

    Type: string
    Source: https://www.packer.io/docs/templates/hcl_templates/locals
  */
  build_dir = "${local.builds_root}/${var.build}"

  /*
    The directory containing HTTP-serving files for the current build.
    Typically holds preseed.cfg, late_command scripts, etc.
    Constructed as <build_dir>/http.

    Type: string
    Source: https://www.packer.io/docs/templates/hcl_templates/locals
  */
  http_dir = "${local.build_dir}/http"

  /*
    Base directory for ISO files. Passed through from var.iso_dir.

    Type: string
    Source: https://www.packer.io/docs/templates/hcl_templates/locals
  */
  iso_dir = var.iso_dir

  /*
    Directory for ISO files of the specific distribution.
    Constructed as <iso_dir>/<var.distro>.

    Type: string
    Source: https://www.packer.io/docs/templates/hcl_templates/locals
  */
  distro_iso_dir = "${var.iso_dir}/${var.distro}"

  /*
    Filename of the ISO image, derived from distribution and version.
    Format: <var.distro>-<var.version>.iso

    Type: string
    Source: https://www.packer.io/docs/templates/hcl_templates/locals
  */
  iso_filename = "${var.distro}-${var.version}.iso"

  /*
    Full absolute path to the ISO image.
    Constructed as <distro_iso_dir>/<iso_filename>.

    Type: string
    Source: https://www.packer.io/docs/templates/hcl_templates/locals
  */
  iso_path = "${local.distro_iso_dir}/${local.iso_filename}"

  /*
    Directory where build artifacts will be stored.
    Passed through from var.artifacts_dir.

    Type: string
    Source: https://www.packer.io/docs/templates/hcl_templates/locals
  */
  artifacts_dir = var.artifacts_dir
}

# Validations with errors

locals {

  /*
    Проверяет существование директории сборки (build_dir).
    Использует fileset для проверки доступности; в случае ошибки вызывает error
    с сообщением, останавливающим сборку.

    Type: (internal validation) bool
    Source: https://www.packer.io/docs/templates/hcl_templates/functions/file/fileset
    Source: https://developer.hashicorp.com/packer/docs/templates/hcl_templates/functions
  */
  _check_build_dir = (
    can(fileset(local.build_dir, "*"))
    ? true
    : error("Build directory not found: ${local.build_dir}")
  )

  /*
    Проверяет существование HTTP-директории (http_dir), содержащей файлы для раздачи.
    Останавливает сборку, если директория отсутствует.

    Type: (internal validation) bool
    Source: https://www.packer.io/docs/templates/hcl_templates/functions/file/fileset
    Source: https://developer.hashicorp.com/packer/docs/templates/hcl_templates/functions
  */
  _check_http_dir = (
    can(fileset(local.http_dir, "*"))
    ? true
    : error("HTTP directory not found: ${local.http_dir}")
  )

  /*
    Проверяет существование базовой ISO-директории (iso_dir).
    Останавливает сборку, если директория не найдена.

    Type: (internal validation) bool
    Source: https://www.packer.io/docs/templates/hcl_templates/functions/file/fileset
    Source: https://developer.hashicorp.com/packer/docs/templates/hcl_templates/functions
  */
  _check_iso_dir = (
    can(fileset(local.iso_dir, "*"))
    ? true
    : error("ISO directory not found: ${local.iso_dir}")
  )

  /*
    Проверяет существование поддиректории дистрибутива внутри ISO-директории.
    Если директория отсутствует, выводит список доступных дистрибутивов
    для помощи пользователю.

    Type: (internal validation) bool
    Source: https://www.packer.io/docs/templates/hcl_templates/functions/file/fileset
    Source: https://developer.hashicorp.com/packer/docs/templates/hcl_templates/functions
  */
  _check_distro_iso_dir = (
    can(fileset(local.distro_iso_dir, "*"))
    ? true
    : error(
        join("\n", [
          "ISO distro directory not found: ${local.distro_iso_dir}",
          "Available distro:",
          join("\n", [for file in sort(fileset(local.iso_dir, "*")) : "  • ${file}"])
        ])
      )
  )

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

  /*
    Проверяет существование ISO-файла по полному пути iso_path.
    Если файл отсутствует, выводит список доступных ISO-файлов в директории дистрибутива.

    Type: (internal validation) bool
    Source: https://www.packer.io/docs/templates/hcl_templates/functions/file/fileexists
    Source: https://developer.hashicorp.com/packer/docs/templates/hcl_templates/functions
  */
  _check_iso_path = (
    fileexists(local.iso_path)
    ? true
    : error(
        join("\n", [
          "ISO image not found: ${local.iso_path}",
          "Available ISO:",
          join("\n", [for file in sort(fileset(local.distro_iso_dir, "*")) : "  • ${file}"])
        ])
      )
  )

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

  /*
    Проверяет существование директории для артефактов (artifacts_dir).
    Останавливает сборку, если директория не найдена.

    Type: (internal validation) bool
    Source: https://www.packer.io/docs/templates/hcl_templates/functions/file/fileset
    Source: https://developer.hashicorp.com/packer/docs/templates/hcl_templates/functions
  */
  _check_artifacts_dir = (
    can(fileset(local.artifacts_dir, "*"))
    ? true
    : error("Artifacts directory not found: ${local.artifacts_dir}")
  )
}
