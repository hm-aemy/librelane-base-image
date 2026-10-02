#!/bin/bash
set -e

mkdir -p /nix/var/nix/daemon-socket

# Run the daemon using the local Nix store
exec env NIX_REMOTE=local nix daemon
