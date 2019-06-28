#!/usr/bin/env bash
set -euxo pipefail
export NIX_PATH="nixpkgs=https://github.com/NixOS/nixpkgs-channels/archive/nixos-18.09.tar.gz";
export NIXOS_CONFIG=`readlink -f configuration.nix `

nixos-rebuild --target-host root@nixcon.martinmyska.cz switch
