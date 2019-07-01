{ pkgs ? import <nixpkgs> { } }:

rec {
  poetry2nix = import (pkgs.fetchFromGitHub {
    owner = "adisbladis";
    repo = "poetry2nix";
    rev = "c2cc4afc1cb5b98b16d9277a629060af91036ef1";
    sha256 = "1v4grhpdxgvlnb2q3qab4r6mimvcckdf91xiw5kqshh8xbncr5ks";
  }) { inherit pkgs; };

  pretix = import ./pretix {
    inherit pkgs poetry2nix;
  };

  pretalx = import ./pretalx {
    inherit pkgs poetry2nix;
  };

}
