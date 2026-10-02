FROM ubuntu:24.04
RUN apt-get update && apt-get install -y python3 python3-pip curl systemd git
ADD install-nix.sh /tmp/install-nix.sh
RUN /tmp/install-nix.sh
RUN pip install "cocotb~=2.0"  --break-system-packages

# Create a non-root user
RUN useradd -m -s /bin/bash student \
    && mkdir -p /workspaces \
    && chown student:student /workspaces
# Default user
USER student
WORKDIR /home/student

ENTRYPOINT ["/bin/bash", "-l"]
