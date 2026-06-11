#!/bin/bash

# Exit on error, but with some error handling
set -e

echo "🔧 Setting up Sim development environment..."

# Change to the workspace root directory
cd /workspace

export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR" ~/.bun/cache
chmod 700 "$TMPDIR" ~/.bun ~/.bun/cache

# Create local development env files with valid secrets before tools read env.
if [ -f "fork-kit/bootstrap-fork.sh" ]; then
  echo "📄 Bootstrapping local fork env files..."
  bash fork-kit/bootstrap-fork.sh
fi

# Set up bun completions (with proper shell detection)
echo "🔧 Setting up shell completions..."
if [ -n "$SHELL" ] && [ -f "$SHELL" ]; then
  SHELL=/bin/bash bun completions 2>/dev/null | sudo tee /etc/bash_completion.d/bun > /dev/null || {
    echo "⚠️ Could not install bun completions, but continuing..."
  }
fi

# Add project commands to shell profile
echo "📄 Setting up project commands..."
# Add sourcing of sim-commands.sh to user's shell config files if they exist
for rcfile in ~/.bashrc ~/.zshrc; do
  if [ -f "$rcfile" ]; then
    # Check if already added
    if ! grep -q "sim-commands.sh" "$rcfile"; then
      echo "" >> "$rcfile"
      echo "# Sim project commands" >> "$rcfile"
      echo "if [ -f /workspace/.devcontainer/sim-commands.sh ]; then" >> "$rcfile"
      echo "  source /workspace/.devcontainer/sim-commands.sh" >> "$rcfile"
      echo "fi" >> "$rcfile"
    fi
  fi
done

# If no rc files exist yet, create a minimal one
if [ ! -f ~/.bashrc ] && [ ! -f ~/.zshrc ]; then
  echo "# Source Sim project commands" > ~/.bashrc
  echo "if [ -f /workspace/.devcontainer/sim-commands.sh ]; then" >> ~/.bashrc
  echo "  source /workspace/.devcontainer/sim-commands.sh" >> ~/.bashrc
  echo "fi" >> ~/.bashrc
fi

echo "🔧 Installing project command wrappers..."
sudo tee /usr/local/bin/sim-setup > /dev/null <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR" ~/.bun/cache
chmod 700 "$TMPDIR" ~/.bun ~/.bun/cache
cd /workspace
bash fork-kit/bootstrap-fork.sh
bun install
cd packages/db
bun run db:migrate
EOF
sudo tee /usr/local/bin/sim-start > /dev/null <<'EOF'
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace && exec bun run dev:full
EOF
sudo tee /usr/local/bin/sim-app > /dev/null <<'EOF'
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace && exec bun run dev
EOF
sudo tee /usr/local/bin/sim-sockets > /dev/null <<'EOF'
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace && exec bun run dev:sockets
EOF
sudo tee /usr/local/bin/sim-migrate > /dev/null <<'EOF'
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace/packages/db && exec bun run db:migrate
EOF
sudo tee /usr/local/bin/sim-generate > /dev/null <<'EOF'
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace/packages/db && exec bunx drizzle-kit generate --config=./drizzle.config.ts
EOF
sudo tee /usr/local/bin/sim-rebuild > /dev/null <<'EOF'
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace && bun run build && exec bun run start
EOF
sudo tee /usr/local/bin/docs-dev > /dev/null <<'EOF'
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace/apps/docs && exec bun run dev
EOF
sudo tee /usr/local/bin/pgc > /dev/null <<'EOF'
#!/usr/bin/env bash
exec env PGPASSWORD=postgres psql -h db -U postgres -d simstudio "$@"
EOF
sudo tee /usr/local/bin/check-db > /dev/null <<'EOF'
#!/usr/bin/env bash
exec env PGPASSWORD=postgres psql -h db -U postgres -c '\l'
EOF
sudo chmod +x /usr/local/bin/sim-setup /usr/local/bin/sim-start /usr/local/bin/sim-app /usr/local/bin/sim-sockets /usr/local/bin/sim-migrate /usr/local/bin/sim-generate /usr/local/bin/sim-rebuild /usr/local/bin/docs-dev /usr/local/bin/pgc /usr/local/bin/check-db

# Clear the welcome message flag to ensure it shows after setup
unset SIM_WELCOME_SHOWN

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Sim development container bootstrap complete!"
echo ""
echo "Open a terminal and run the heavier setup when you are ready:"
echo ""
echo "  sim-setup"
echo "  sim-start"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Exit successfully regardless of any previous errors
exit 0 