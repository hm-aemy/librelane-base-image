FROM ubuntu:26.04

# System dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python-is-python3 \
    curl \
    ca-certificates \
    git \
    xz-utils \
    libxcursor1 \
    libx11-xcb1 \
    libxi6 \
    libxrandr2 \
    libxinerama1 \
    libxkbcommon-x11-0 \
    libgl1 \
    libegl1 \
    libwayland-egl1\
    locales \
    sudo \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# Locale configuration
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV LIBGL_ALWAYS_SOFTWARE=1

# Enable sudo for the ubuntu user
RUN usermod -aG sudo ubuntu \
    && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" \
       > /etc/sudoers.d/ubuntu \
    && chmod 0440 /etc/sudoers.d/ubuntu

# Install Nix
COPY install-nix.sh /tmp/install-nix.sh
RUN bash /tmp/install-nix.sh

# Nix configuration
ENV PATH="/nix/var/nix/profiles/default/bin:${PATH}"
ENV NIX_REMOTE="daemon"

# --------------------------------------------------
# OSS CAD Suite
# --------------------------------------------------

ARG OSS_CAD_VERSION=2026-09-30

RUN set -eux; \
    OSS_CAD_DATE="$(echo "$OSS_CAD_VERSION" | tr -d '-')"; \
    OSS_CAD_URL="https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${OSS_CAD_VERSION}/oss-cad-suite-linux-x64-${OSS_CAD_DATE}.tgz"; \
    curl -fL --retry 3 "$OSS_CAD_URL" -o /tmp/oss-cad-suite.tgz; \
    mkdir -p /opt; \
    tar -xzf /tmp/oss-cad-suite.tgz -C /opt; \
    test -d /opt/oss-cad-suite/bin; \
    rm /tmp/oss-cad-suite.tgz

ENV PATH="/opt/oss-cad-suite/bin:${PATH}"

# Container startup
COPY start-container.sh /usr/local/bin/start-container.sh
RUN chmod +x /usr/local/bin/start-container.sh

USER root

ENTRYPOINT ["/usr/local/bin/start-container.sh"]
