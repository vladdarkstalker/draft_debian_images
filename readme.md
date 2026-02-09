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







Для PROD пароли не пишем в репозиторий, а задаём через CI/CD variables:

build_astra_arm:
  stage: build
  variables:
    PACKER_SSH_PASSWORD: $ASTRA_ARM_PASSWORD
  script:
    - packer build \
        -var "overlay=astra-arm" \
        -var "ssh_password=$PACKER_SSH_PASSWORD" \
        packer/astra/astra-arm.pkr.hcl


dev можно использовать vars.hcl

prod берёт пароль из GitLab


provisioner "shell" {
  inline = [
    "echo 'Creating admin users...'",
    %{ for admin in local.admins ~}
      "useradd -m -s /bin/bash ${admin.login}",
      "echo '${admin.login}:${admin.password}' | chpasswd",
    %{ endfor ~}
  ]
}

// [{"login":"astra-admin","password":"$ASTRA_ADMIN_PASSWORD"},{"login":"srv-admin","password":"$SRV_ADMIN_PASSWORD"}]




disk_size = "150G"
format = "qcow2"
accelerator = "kvm"
ssh_timeout = "20m"
vm_name = "arm_alse18"
net_device = "virtio-net"
disk_interface = "virtio"
boot_wait = "10s"


ssh_username = split(":", env("PACKER_SSH_CREDENTIALS"))[0]
ssh_password = split(":", env("PACKER_SSH_CREDENTIALS"))[1]



# Создайте директорию для хранения secrets
mkdir -p secrets/

# Создайте vault файл
ansible-vault create secrets/vault.yml

echo "your_vault_password" > secrets/vault_password.txt
chmod 600 secrets/vault_password.txt

# secrets/vault.yml
# Все значения здесь зашифрованы

# Пример для пользователей
users:
  admin:
    username: "adminuser"
    password: "StrongAdminPass123!"
    ssh_key: "ssh-rsa AAAAB3Nz..."
  
  app_user:
    username: "deployer"
    password: "DeployPass456!"
    ssh_key: "ssh-rsa AAAAB3Nz..."

# Пароли для баз данных
databases:
  postgres:
    admin_password: "PgAdminPass789!"
    app_db_password: "AppDBPass321!"

# API ключи и токены
api_keys:
  aws_access_key: "AKIAIOSFODNN7EXAMPLE"
  aws_secret_key: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
  github_token: "ghp_abc123def456"

# Другие секреты
secrets:
  secret_key_base: "abc123def456ghi789jkl012mno345pqr678stu901vwx234yz5"