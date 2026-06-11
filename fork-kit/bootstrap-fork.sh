#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

secret() {
  openssl rand -hex 32
}

write_file_if_missing() {
  local target="$1"
  local content="$2"

  if [ -f "$target" ]; then
    echo "Keeping existing $target"
    return
  fi

  mkdir -p "$(dirname "$target")"
  printf "%s\n" "$content" >"$target"
  echo "Wrote $target"
}

require_command openssl

BETTER_AUTH_SECRET_VALUE="$(secret)"
ENCRYPTION_KEY_VALUE="$(secret)"
API_ENCRYPTION_KEY_VALUE="$(secret)"
INTERNAL_API_SECRET_VALUE="$(secret)"
POSTGRES_PASSWORD_VALUE="${POSTGRES_PASSWORD:-postgres}"

COMMON_ENV="POSTGRES_USER=postgres
POSTGRES_PASSWORD=${POSTGRES_PASSWORD_VALUE}
POSTGRES_DB=simstudio
POSTGRES_PORT=5432
DATABASE_URL=postgresql://postgres:${POSTGRES_PASSWORD_VALUE}@localhost:5432/simstudio
BETTER_AUTH_URL=http://localhost:3000
NEXT_PUBLIC_APP_URL=http://localhost:3000
BETTER_AUTH_SECRET=${BETTER_AUTH_SECRET_VALUE}
ENCRYPTION_KEY=${ENCRYPTION_KEY_VALUE}
API_ENCRYPTION_KEY=${API_ENCRYPTION_KEY_VALUE}
INTERNAL_API_SECRET=${INTERNAL_API_SECRET_VALUE}
SOCKET_SERVER_URL=http://localhost:3002
NEXT_PUBLIC_SOCKET_URL=http://localhost:3002
BILLING_CURRENCY=eur"

write_file_if_missing ".env" "$COMMON_ENV"
write_file_if_missing "apps/sim/.env" "$COMMON_ENV"
write_file_if_missing "apps/realtime/.env" "NODE_ENV=development
PORT=3002
DATABASE_URL=postgresql://postgres:${POSTGRES_PASSWORD_VALUE}@localhost:5432/simstudio
BETTER_AUTH_URL=http://localhost:3000
BETTER_AUTH_SECRET=${BETTER_AUTH_SECRET_VALUE}
INTERNAL_API_SECRET=${INTERNAL_API_SECRET_VALUE}
NEXT_PUBLIC_APP_URL=http://localhost:3000"
write_file_if_missing "packages/db/.env" "DATABASE_URL=postgresql://postgres:${POSTGRES_PASSWORD_VALUE}@localhost:5432/simstudio"

write_file_if_missing ".github/workflows/auto-sync.yml" "name: Auto Sync Upstream

on:
  schedule:
    - cron: '17 3 * * *'
  workflow_dispatch:

permissions:
  contents: write
  pull-requests: write

concurrency:
  group: auto-sync-upstream
  cancel-in-progress: true

jobs:
  sync:
    name: Sync upstream main
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v6
        with:
          fetch-depth: 0
          token: \${{ secrets.GITHUB_TOKEN }}

      - name: Configure Git
        run: |
          git config user.name 'github-actions[bot]'
          git config user.email '41898282+github-actions[bot]@users.noreply.github.com'

      - name: Fetch upstream
        run: |
          git remote add upstream https://github.com/simstudioai/sim.git || git remote set-url upstream https://github.com/simstudioai/sim.git
          git fetch upstream main

      - name: Prepare sync branch
        run: |
          git checkout -B auto-sync/upstream-main origin/main
          git merge --no-edit upstream/main
          git push --force-with-lease origin auto-sync/upstream-main

      - name: Open or update pull request
        env:
          GH_TOKEN: \${{ secrets.GITHUB_TOKEN }}
        run: |
          gh pr view auto-sync/upstream-main --base main >/dev/null 2>&1 || gh pr create --base main --head auto-sync/upstream-main --title 'chore(sync): update fork from upstream main' --body 'Automated upstream sync from simstudioai/sim main.'
"

echo "Fork bootstrap complete."
