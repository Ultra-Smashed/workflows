FROM oven/bun:1.3.13

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    bash-completion \
    ca-certificates \
    git \
    g++ \
    curl \
    wget \
    make \
    jq \
    sudo \
    vim \
    nano \
    zsh \
    pkg-config \
    python3 \
    postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# Create a non-root user with matching UID/GID
ARG USERNAME=bun
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN if ! getent group $USER_GID >/dev/null; then \
        groupadd --gid $USER_GID $USERNAME; \
    fi

RUN if ! getent passwd $USER_UID >/dev/null; then \
        useradd --uid $USER_UID --gid $USER_GID --create-home --shell /bin/bash $USERNAME; \
    fi

# Add sudo support
RUN echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set up shell environment
RUN echo "export PATH=\$PATH:/home/$USERNAME/.bun/bin" >> /etc/profile

RUN cat > /usr/local/bin/sim-setup <<'EOF' \
    && cat > /usr/local/bin/sim-start <<'EOF2' \
    && cat > /usr/local/bin/sim-app <<'EOF3' \
    && cat > /usr/local/bin/sim-sockets <<'EOF4' \
    && cat > /usr/local/bin/sim-migrate <<'EOF5' \
    && cat > /usr/local/bin/sim-generate <<'EOF6' \
    && cat > /usr/local/bin/sim-rebuild <<'EOF7' \
    && cat > /usr/local/bin/docs-dev <<'EOF8' \
    && cat > /usr/local/bin/pgc <<'EOF9' \
    && cat > /usr/local/bin/check-db <<'EOF10' \
    && chmod +x /usr/local/bin/sim-setup /usr/local/bin/sim-start /usr/local/bin/sim-app /usr/local/bin/sim-sockets /usr/local/bin/sim-migrate /usr/local/bin/sim-generate /usr/local/bin/sim-rebuild /usr/local/bin/docs-dev /usr/local/bin/pgc /usr/local/bin/check-db
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
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace && exec bun run dev:full
EOF2
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace && exec bun run dev
EOF3
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace && exec bun run dev:sockets
EOF4
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace/packages/db && exec bun run db:migrate
EOF5
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace/packages/db && exec bunx drizzle-kit generate --config=./drizzle.config.ts
EOF6
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace && bun run build && exec bun run start
EOF7
#!/usr/bin/env bash
export TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
cd /workspace/apps/docs && exec bun run dev
EOF8
#!/usr/bin/env bash
exec env PGPASSWORD=postgres psql -h db -U postgres -d simstudio "$@"
EOF9
#!/usr/bin/env bash
exec env PGPASSWORD=postgres psql -h db -U postgres -c '\l'
EOF10

WORKDIR /workspace

# Expose the ports we're interested in
EXPOSE 3000
EXPOSE 3001
EXPOSE 3002
EXPOSE 3003
