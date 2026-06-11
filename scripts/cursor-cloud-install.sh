#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
export PATH="$BUN_INSTALL/bin:$PATH"

install_bun() {
  if command -v bun >/dev/null 2>&1; then
    return
  fi

  curl -fsSL https://bun.sh/install | bash
  export PATH="$BUN_INSTALL/bin:$PATH"
}

install_docker() {
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    return
  fi

  if ! command -v sudo >/dev/null 2>&1 || ! sudo -n true >/dev/null 2>&1; then
    echo "Docker/Compose is missing and passwordless sudo is unavailable." >&2
    exit 1
  fi

  sudo apt-get update
  sudo apt-get install -y docker.io docker-compose-v2
}

install_bun
install_docker

bash fork-kit/bootstrap-fork.sh
bun install
