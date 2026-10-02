FROM ubuntu:24.04

# System dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    curl \
    ca-certificates \
    git \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Nix
COPY install-nix.sh /tmp/install-nix.sh
RUN bash /tmp/install-nix.sh

# Nix configuration
ENV PATH="/nix/var/nix/profiles/default/bin:${PATH}"
ENV NIX_REMOTE="daemon"

# Python dependencies
RUN pip install "cocotb~=2.0" --break-system-packages

# Container startup
COPY start-container.sh /usr/local/bin/start-container.sh
RUN chmod +x /usr/local/bin/start-container.sh

USER root

ENTRYPOINT ["/usr/local/bin/start-container.sh"]
