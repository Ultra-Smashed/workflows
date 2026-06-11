#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
export PATH="$BUN_INSTALL/bin:$PATH"

docker_ready() {
  docker info >/dev/null 2>&1 || sudo docker info >/dev/null 2>&1
}

compose_up_db() {
  if docker info >/dev/null 2>&1; then
    docker compose -f docker-compose.local.yml up -d db
    return
  fi

  sudo docker compose -f docker-compose.local.yml up -d db
}

start_system_docker() {
  if ! command -v sudo >/dev/null 2>&1 || ! sudo -n true >/dev/null 2>&1; then
    return 1
  fi

  if command -v systemctl >/dev/null 2>&1 && sudo systemctl start docker >/dev/null 2>&1; then
    return 0
  fi

  if command -v service >/dev/null 2>&1 && sudo service docker start >/dev/null 2>&1; then
    return 0
  fi

  return 1
}

start_fallback_dockerd() {
  if ! command -v sudo >/dev/null 2>&1 || ! sudo -n true >/dev/null 2>&1; then
    echo "Docker daemon is not running and passwordless sudo is unavailable." >&2
    exit 1
  fi

  mkdir -p /tmp/cursor-dockerd
  sudo pkill dockerd >/dev/null 2>&1 || true
  sudo pkill containerd >/dev/null 2>&1 || true
  sudo dockerd \
    --host=unix:///var/run/docker.sock \
    --iptables=false \
    --bridge=none \
    --ip-forward=false \
    --storage-driver=vfs \
    >/tmp/cursor-dockerd/dockerd.log 2>&1 &
}

wait_for_docker() {
  for _ in $(seq 1 30); do
    if docker_ready; then
      return 0
    fi
    sleep 1
  done

  echo "Docker did not become ready. Recent daemon logs:" >&2
  if [ -f /tmp/cursor-dockerd/dockerd.log ]; then
    tail -n 80 /tmp/cursor-dockerd/dockerd.log >&2
  fi
  exit 1
}

if ! docker_ready; then
  start_system_docker || start_fallback_dockerd
  wait_for_docker
fi

compose_up_db
