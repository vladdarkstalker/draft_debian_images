# Packer Builder for Debian-based Linux Distributions

This repository provides a flexible and reusable **Packer template framework** for building fully automated virtual machine images of Debian-based Linux distributions.

The project is designed to be **builder-agnostic**, allowing you to use the same structure with:

* QEMU
* VirtualBox
* VMware
* Hyper-V (experimental)
* any other supported Packer builder

It supports unattended installation via preseed and is easily extensible for new distributions and build targets.

## Features

* **Builder-agnostic design** — works with multiple hypervisors
* **Fully automated installation** using Debian preseed
* **Multi-distribution ready** (Debian, Ubuntu, derivatives)
* **HTTP delivery of install configs**
* **Variable-driven configuration**
* **Clean project structure**
* **Easy extensibility for new builds**
* **CI/CD friendly**

## Supported Distributions

Tested with:

* Debian 11 (Bullseye), 12 (Bookworm)
* Ubuntu 20.04 LTS (Focal Fossa), 22.04 LTS (Jammy Jellyfish)
* Other Debian-based distributions (e.g., Astra Linux, Linux Mint) can be added with appropriate preseed files.

Any Debian-based distribution can be supported by providing:

* a compatible ISO
* an appropriate preseed (or autoinstall) configuration

## Requirements

* **Packer ≥ 1.9.0** (1.14+ recommended)
* ISO image of the target distribution
* Supported hypervisor for your chosen builder:

| Builder    | Requirement        |
| ---------- | ------------------ |
| qemu       | QEMU/KVM or WHPX   |
| virtualbox | VirtualBox         |
| vmware     | VMware Workstation |
| hyperv     | Hyper-V (optional) |

* At least **20 GB free disk space per build**

## Project Structure

```
.
├── builds/ # Build definitions
│ ├── debian-12/ # Example: Debian 12 build
│ │ ├── http/ # Files served by Packer HTTP server
│ │ │ └── preseed.cfg # Preseed file for this build
│ │ └── <other files> # Additional scripts or configs
│ └── ubuntu-22.04/ # Example: Ubuntu 22.04 build
│   └── http/
│   └── preseed.cfg
├── iso/ # ISO files (expected to be organised by distribution)
│ ├── debian/
│ │ ├── debian-11.iso
│ │ └── debian-12.iso
│ └── ubuntu/
│   ├── ubuntu-20.04.iso
│   └── ubuntu-22.04.iso
├── artifacts/ # Output directory for built images (created by Packer)
├── variables.pkr.hcl # Variable definitions (common to all builders)
├── qemu.pkr.hcl # Example builder configuration (QEMU)
├── virtualbox.pkr.hcl # Example builder configuration (VirtualBox)
└── .env.example # Example environment variable file
```

## Configuration Variables

Variables can be set via:

* CLI: `-var`
* environment variables
* `.env` file
* defaults in `variables.pkr.hcl`

### Core Variables

| Variable        | Description                             | Required |
| --------------- | --------------------------------------- | -------- |
| `project_root`  | Absolute path to project root           | yes      |
| `distro`        | Distribution name (e.g. debian, ubuntu) | yes      |
| `version`       | Distribution version                    | yes      |
| `build`         | Build directory name under `builds/`    | yes      |
| `iso_dir`       | Base directory with ISOs                | yes      |
| `artifacts_dir` | Output directory for images             | yes      |
| `disk_size`     | Disk size in GB                         | yes      |
| `ssh_login`     | SSH username                            | yes      |
| `ssh_password`  | SSH password                            | yes      |

---

## Environment Setup (Optional)

Create `.env` from `.env.example`:

```bash
PACKER_ISO_DIR="/absolute/path/to/iso"
PACKER_ARTIFACTS_DIR="/absolute/path/to/artifacts"

PACKER_SSH_LOGIN="admin"
PACKER_SSH_PASSWORD="password"
```

Load it:

```bash
set -a
source .env
set +a
```

---

## Quick Start

### Place ISO

Example:

```
iso/debian/debian-12.iso
```

---

### Create build directory

```
builds/debian-12/http/preseed.cfg
```

---

### Run build (QEMU example)

```bash
packer build \
  -force \
  -on-error=abort \
  -var "project_root=$(pwd)" \
  -var "distro=debian" \
  -var "version=12" \
  -var "build=debian-12" \
  -var "disk_size=40" \
  -var "ssh_login=admin" \
  -var "ssh_password=password" \
  .
```

---

## Using a Specific Builder

If multiple sources exist:

```bash
packer build -only="qemu.debian-12" .
```

---

## Adding a New Distribution

1. Create:

```
builds/<name>/http/
```

2. Add installer answers:

```
preseed.cfg
```

3. Place ISO in:

```
iso/<distro>/
```

4. Run with:

```bash
-var "build=<name>"
```

---

## Preseed Notes

The project currently uses **classic Debian preseed automation**.

The design allows future support for:

* Ubuntu autoinstall
* cloud-init
* other unattended installers

---

## Troubleshooting

### Enable Packer debug logs

```bash
PACKER_LOG=1 packer build ...
```

---

### Enable verbose installer logs

Remove `quiet` and add to kernel params:

```
loglevel=7 systemd.log_level=debug systemd.log_target=console debug
```

---

### When GRUB is skipped too fast

Common fixes:

* increase `boot_wait`
* enable QEMU boot menu
* adjust `boot_command` timing

---

## 🔧 Boot Automation

The `boot_command` sends keystrokes to the VM to:

1. Interrupt bootloader
2. Edit kernel line
3. Append automation parameters
4. Boot installer

Example:

```hcl
boot_command = [
  "<leftShiftOn><wait10><leftShiftOff>",
  "e<wait>",
  "<down><down><end>",
  " auto=true preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg",
  "<f10>"
]
```

Timing may need tuning per distribution.

## Contributing

Contributions are welcome.

Please open an issue or submit a pull request.

## License

MIT License.

---

Пометки:

- расписать что значит universal в названиях (это значит общий шаблон);
├── builds
│   ├── alse18-universal-qemu
│   ├── debian-qemu
│   ├── universal
│   └── universal-qemu

- расписать правила именования в iso дирректории (название дирректории = названию дистрибутива + версия);
├── iso
│   ├── alse
│   │   └── alse-1.8.1.iso
│   ├── debian
│   │   └── debian-13.1.0.iso
│   └── ubuntu
│       └── ubuntu-24.04.3.iso


Версионность

Будет 5 “идентификатора”:
- distro: alse (Astra), debian, ubuntu
- distro_version: версия ISO/дистрибутива (например 1.8.4, 12.5, 24.10)
- image_version: версия твоего образа (SemVer: MAJOR.MINOR.PATCH, например 1.0.3)
- build_id: уникальность билда (CI pipeline id + sha или timestamp)
- provider: qemu, virtualbox etc.

Главное правило:
- distro_version меняется, когда меняется ISO
- image_version меняется, когда меняешь preseed/ansible/packer (поведение образа)
- build_id меняется всегда при каждом запуске (чтобы артефакты копились и не затирались)

<comment>-<flavor>-<distro>-<distro_version>-<provider>-<image_version>+<build_id>

build_id правильно (локально + GitLab)

run.sh
build_id="$(date +%Y%m%d-%H%M)-$(git rev-parse --short HEAD 2>/dev/null || echo manual)"

GitLab CI
build_id="${CI_PIPELINE_ID}-${CI_COMMIT_SHORT_SHA}"

builds/
  alse/
    universal-qemu/
      http/
        preseed/
          base.cfg
          flavors/
            arm.cfg
            arm-2.cfg
            srv.cfg
      ansible/
        site.yml
        group_vars/
          all.yml
          arm.yml
          arm-2.yml
          srv.yml
        roles/
          common/
          arm/
          srv/
      packer/
        source.pkr.hcl
        locals.pkr.hcl
        variables.pkr.hcl
        build.pkr.hcl
      run.sh

И в boot_command ты просто выбираешь entrypoint:
preseed/url=http://{{.HTTPIP}}:{{.HTTPPort}}/entrypoints/arm.cfg


