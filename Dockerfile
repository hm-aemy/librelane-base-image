FROM ubuntu:latest
RUN apt-get update && apt-get install -y python3-full python3-pip curl systemd git
ADD install-nix.sh /tmp/install-nix.sh
RUN /tmp/install-nix.sh
RUN pip install "cocotb~=2.0"
ENTRYPOINT ["/bin/bash", "-l"]