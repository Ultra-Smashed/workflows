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

WORKDIR /workspace

# Expose the ports we're interested in
EXPOSE 3000
EXPOSE 3001
EXPOSE 3002
EXPOSE 3003
