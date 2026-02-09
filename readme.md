# Supported distributions
- Debian: 11 (Bullseye), 12 (Bookworm)
- Ubuntu: 20.04 LTS, 22.04 LTS
- Astra Linux 1.8 (Debian)

# Обязательные аргументы для построения образа:
- overlay
- ssh_login or PACKER_SSH_LOGIN
- ssh_password or PACKER_SSH_PASSWORD

# Images:
- alse18
- alse18-arm
- alse18-srv

# Целевая модель запуска
packer build \
  -var project_root=$PWD \
  -var distro=alse \
  -var version=1.8.1 \
  -var build=universal
