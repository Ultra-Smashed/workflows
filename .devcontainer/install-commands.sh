#!/usr/bin/env bash
set -euo pipefail

cat > /usr/local/bin/sim-setup <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR" ~/.bun/cache
sudo chown -R "$(id -u):$(id -g)" "$TMPDIR" ~/.bun >/dev/null 2>&1 || true
chmod 700 "$TMPDIR" >/dev/null 2>&1 || true
cd /workspace
bash fork-kit/bootstrap-fork.sh
bun install
cd packages/db
bun run db:migrate
EOF

cat > /usr/local/bin/sim-start <<'EOF'
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace && exec bun run dev:full
EOF

cat > /usr/local/bin/sim-app <<'EOF'
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace && exec bun run dev
EOF

cat > /usr/local/bin/sim-sockets <<'EOF'
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace && exec bun run dev:sockets
EOF

cat > /usr/local/bin/sim-migrate <<'EOF'
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace/packages/db && exec bun run db:migrate
EOF

cat > /usr/local/bin/sim-generate <<'EOF'
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace/packages/db && exec bunx drizzle-kit generate --config=./drizzle.config.ts
EOF

cat > /usr/local/bin/sim-rebuild <<'EOF'
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace && bun run build && exec bun run start
EOF

cat > /usr/local/bin/docs-dev <<'EOF'
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace/apps/docs && exec bun run dev
EOF

cat > /usr/local/bin/pgc <<'EOF'
#!/usr/bin/env bash
exec env PGPASSWORD=postgres psql -h db -U postgres -d simstudio "$@"
EOF

cat > /usr/local/bin/check-db <<'EOF'
#!/usr/bin/env bash
exec env PGPASSWORD=postgres psql -h db -U postgres -c '\l'
EOF

chmod +x /usr/local/bin/sim-setup \
  /usr/local/bin/sim-start \
  /usr/local/bin/sim-app \
  /usr/local/bin/sim-sockets \
  /usr/local/bin/sim-migrate \
  /usr/local/bin/sim-generate \
  /usr/local/bin/sim-rebuild \
  /usr/local/bin/docs-dev \
  /usr/local/bin/pgc \
  /usr/local/bin/check-db
