#!/bin/bash
set -e

echo "Starting Nix daemon..."

exec nix daemon
