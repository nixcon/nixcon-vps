{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.nixops
  ];
  NIX_PATH = "nixpkgs=https://github.com/NixOS/nixpkgs-channels/archive/nixos-18.09.tar.gz";
}
