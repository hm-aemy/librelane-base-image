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

# Make Nix available to all users
ENV PATH="/nix/var/nix/profiles/default/bin:${PATH}"
ENV NIX_REMOTE="daemon"

# Python dependencies
RUN pip install "cocotb~=2.0" --break-system-packages

# Create development user
RUN useradd -m -s /bin/bash student

# Container startup
COPY start-container.sh /usr/local/bin/start-container.sh
RUN chmod +x /usr/local/bin/start-container.sh

# Start the service with root privileges
USER root

ENTRYPOINT ["/usr/local/bin/start-container.sh"]
