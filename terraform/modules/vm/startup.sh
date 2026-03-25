#!/bin/bash

set -eux
export DEBIAN_FRONTEND=noninteractive

LOG_FILE="/var/log/startup-script.log"
exec > >(tee -a $LOG_FILE) 2>&1

echo "=== STARTUP SCRIPT BEGIN ==="

apt update -y
apt install -y ca-certificates curl gnupg git lsb-release tree

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | tee /etc/apt/keyrings/docker.asc > /dev/null

chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update -y
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker

apt install -y python3 python3-pip python3-venv
pip3 install gdown

usermod -aG docker danz

mkdir -p /srv

sleep 10

echo "=== CLONE REPO ==="

GITHUB_TOKEN="${GITHUB_TOKEN}"

set +x

if [ ! -d "/srv/.git" ]; then
  git clone https://${GITHUB_TOKEN}@github.com/Dans9881/infra-danz.git /srv
else
  echo "Repo already exists, skipping clone"
fi

set -x

chown -R danz:danz /srv

cd /srv

chmod +x deploy.sh

./deploy.sh

echo "=== STARTUP SCRIPT DONE ==="