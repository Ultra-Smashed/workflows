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
    git \
    iptables \
    jq \
    openssh-client \
    openssl \
    postgresql-client \
    ripgrep \
    sudo \
    tmux \
    unzip \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash ubuntu \
  && usermod -aG docker ubuntu \
  && echo "ubuntu ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ubuntu \
  && chmod 0440 /etc/sudoers.d/ubuntu

USER ubuntu
WORKDIR /workspace

RUN curl -fsSL https://bun.sh/install | bash
