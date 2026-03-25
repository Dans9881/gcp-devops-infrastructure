#!/bin/bash

set -e

docker network create web || true
docker network create monitoring || true
docker network create cicd || true
docker network create security || true

echo "=== DEPLOY CORE ==="
cd /srv/core/traefik
docker compose up -d

echo "=== FIX PERMISSION MONITORING ==="
mkdir -p /srv/monitoring/data/grafana
mkdir -p /srv/monitoring/data/prometheus

chown -R 472:472 /srv/monitoring/data/grafana
chown -R 65534:65534 /srv/monitoring/data/prometheus

echo "=== DEPLOY MONITORING ==="
cd /srv/monitoring
docker compose up -d

echo "=== DEPLOY FLASK APP ==="
cd /srv/apps

# ========================
# CLONE REPO (FIRST TIME)
# ========================
if [ ! -d "flask-ml-app" ]; then
  git clone https://github.com/Dans9881/flask-ml-app.git
fi

cd flask-ml-app

# ========================
# UPDATE CODE
# ========================
git pull

# ========================
# DOWNLOAD MODEL
# ========================
echo "=== DOWNLOAD MODEL ==="

mkdir -p static/model
cd static/model

MODEL1_NAME="vgg19_fold-min-5.h5"
MODEL2_NAME="result-model_dua_temp.h5"

MODEL1_ID="1L7YPV3SLl08X6otuV1epolnwh1tGNEsq"
MODEL2_ID="1RgNc29CR98pcg3krGxA784Zxv2xx93pQ"

# model 1
if [ ! -f "$MODEL1_NAME" ]; then
  echo "Downloading $MODEL1_NAME..."
  gdown --id $MODEL1_ID -O $MODEL1_NAME
else
  echo "$MODEL1_NAME already exists, skip"
fi

# model 2
if [ ! -f "$MODEL2_NAME" ]; then
  echo "Downloading $MODEL2_NAME..."
  gdown --id $MODEL2_ID -O $MODEL2_NAME
else
  echo "$MODEL2_NAME already exists, skip"
fi

cd ../..

# ========================
# BUILD & RUN CONTAINER
# ========================
echo "=== BUILD & RUN CONTAINER ==="
docker compose up -d --build

echo "=== DEPLOY DONE ==="