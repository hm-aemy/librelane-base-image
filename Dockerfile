FROM ubuntu:24.04

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
    sudo \
    && rm -rf /var/lib/apt/lists/*

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

# Python dependencies
RUN pip install "cocotb~=2.0" --break-system-packages

# Install Surfer waveform viewer
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    build-essential \
    pkg-config \
    libssl-dev \
    libfontconfig1-dev \
    libxkbcommon-dev \
    libwayland-dev \
    libasound2-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf \
    https://sh.rustup.rs | sh -s -- -y --profile minimal \
    && /root/.cargo/bin/cargo install \
        --git https://gitlab.com/surfer-project/surfer.git \
        surfer --locked \
    && cp /root/.cargo/bin/surfer /usr/local/bin/surfer \
    && rm -rf /root/.cargo /root/.rustup

#Install Verilator
ARG VERILATOR_VERSION=v5.050

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    autoconf \
    make \
    g++ \
    flex \
    bison \
    perl \
    python3 \
    libfl-dev \
    zlib1g-dev \
    help2man \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch ${VERILATOR_VERSION} \
        https://github.com/verilator/verilator.git /tmp/verilator \
    && cd /tmp/verilator \
    && autoconf \
    && ./configure --prefix=/usr/local \
    && make -j 2 \
    && make install \
    && cd / \
    && rm -rf /tmp/verilator

# Container startup
COPY start-container.sh /usr/local/bin/start-container.sh
RUN chmod +x /usr/local/bin/start-container.sh

USER root

ENTRYPOINT ["/usr/local/bin/start-container.sh"]
