#!/bin/bash
# Sim Project Commands
# Source this file to add project-specific commands to your shell
# Add to your ~/.bashrc or ~/.zshrc: source /workspace/.devcontainer/sim-commands.sh

sim-start() {
  cd /workspace && bun run dev:full
}

sim-app() {
  cd /workspace && bun run dev
}

sim-sockets() {
  cd /workspace && bun run dev:sockets
}

sim-migrate() {
  cd /workspace/packages/db && bun run db:migrate
}

sim-generate() {
  cd /workspace/packages/db && bunx drizzle-kit generate --config=./drizzle.config.ts
}

sim-rebuild() {
  cd /workspace && bun run build && bun run start
}

docs-dev() {
  cd /workspace/apps/docs && bun run dev
}

# Database connection helpers
pgc() {
  PGPASSWORD=postgres psql -h db -U postgres -d simstudio
}

check-db() {
  PGPASSWORD=postgres psql -h db -U postgres -c '\l'
}

# Default to workspace directory
cd /workspace 2>/dev/null || true

# Welcome message - show once per session
if [ -z "$SIM_WELCOME_SHOWN" ]; then
  export SIM_WELCOME_SHOWN=1

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🚀 Sim Development Environment"
  echo ""
  echo "Project commands:"
  echo "  sim-start      - Start app + socket server"
  echo "  sim-app        - Start only main app"
  echo "  sim-sockets    - Start only socket server"
  echo "  sim-migrate    - Push schema changes"
  echo "  sim-generate   - Generate migrations"
  echo ""
  echo "Database:"
  echo "  pgc            - Connect to PostgreSQL"
  echo "  check-db       - List databases"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
fi
