#!/usr/bin/env nix-shell
#! nix-shell shell.nix -i bash
set -euxo pipefail
mkdir -p state

nixops deploy -d nixcon --state ./state/deployment-state.nixops
nixops export -d nixcon --state ./state/deployment-state.nixops > deployment-state.json
