{ pkgs ? import <nixpkgs> { } }:

rec {

  poetry2nix = import (pkgs.fetchFromGitHub {
    owner = "adisbladis";
    repo = "poetry2nix";
    rev = "6a45f49aae0ece24c634995eb75d2942be87a4cd";
    sha256 = "1bkzncn74mpjj4sf945caxnx3kyi88x8g73q6724qi76g5izccqq";
  }) { inherit pkgs; };

  pretix = import ./pretix {
    inherit pkgs poetry2nix;
  };

  pretalx = import ./pretalx {
    inherit pkgs poetry2nix;
  };

}
