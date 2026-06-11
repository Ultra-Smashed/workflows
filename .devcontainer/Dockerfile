FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV BUN_INSTALL=/home/bun/.bun
ENV PATH=/home/bun/.bun/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

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
    unzip \
  && rm -rf /var/lib/apt/lists/*

ARG USERNAME=bun
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN if getent passwd vscode >/dev/null; then userdel -r vscode; fi \
  && if getent group $USER_GID >/dev/null; then groupmod -n $USERNAME "$(getent group $USER_GID | cut -d: -f1)"; else groupadd --gid $USER_GID $USERNAME; fi \
  && useradd --uid $USER_UID --gid $USER_GID --create-home --shell /bin/bash $USERNAME \
  && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME

RUN echo "export PATH=\$PATH:/home/$USERNAME/.bun/bin" >> /etc/profile

USER bun
RUN curl -fsSL https://bun.sh/install | bash -s "bun-v1.3.13"
USER root

COPY .devcontainer/install-commands.sh /tmp/install-commands.sh
RUN bash /tmp/install-commands.sh && rm /tmp/install-commands.sh

WORKDIR /workspace

# Expose the ports we're interested in
EXPOSE 3000
EXPOSE 3001
EXPOSE 3002
EXPOSE 3003
