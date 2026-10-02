#!/bin/bash
set -e

curl --proto '=https' --tlsv1.2 -sSf -L \
    https://install.determinate.systems/nix | \
    sh -s -- install linux \
        --no-confirm \
        --init none \
        --extra-conf "
            experimental-features = nix-command flakes
            sandbox = false
            extra-substituters = https://nix-cache.fossi-foundation.org
            extra-trusted-public-keys = nix-cache.fossi-foundation.org:3+K59iFwXqKsL7BNu6Guy0v+uTlwsxYQxjspXzqLYQs=
        "
