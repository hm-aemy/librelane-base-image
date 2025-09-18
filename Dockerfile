FROM ubuntu:24.04
RUN apt-get update && apt-get install -y python3 python3-pip curl systemd git
ADD install-nix.sh /tmp/install-nix.sh
RUN /tmp/install-nix.sh
RUN pip install "cocotb~=2.0"  --break-system-packages
ENTRYPOINT ["/bin/bash", "-l"]