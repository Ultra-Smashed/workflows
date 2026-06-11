FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV BUN_INSTALL=/home/ubuntu/.bun
ENV PATH=/home/ubuntu/.bun/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    docker-compose-v2 \
    docker.io \
    g++ \
    git \
    iptables \
    jq \
    make \
    openssh-client \
    openssl \
    postgresql-client \
    pkg-config \
    python3 \
    ripgrep \
    sudo \
    tmux \
    unzip \
  && rm -rf /var/lib/apt/lists/*

RUN if ! getent passwd ubuntu >/dev/null; then useradd -m -s /bin/bash ubuntu; fi \
  && usermod -aG docker ubuntu \
  && echo "ubuntu ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ubuntu \
  && chmod 0440 /etc/sudoers.d/ubuntu

USER ubuntu
WORKDIR /workspace

RUN curl -fsSL https://bun.sh/install | bash -s "bun-v1.3.13"
