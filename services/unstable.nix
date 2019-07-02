let
  src = builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs-channels/archive/nixos-unstable.tar.gz";
  };

  pkgs = import src { };

in import (pkgs.stdenv.mkDerivation {
  name = "nixpkgs";

  inherit src;

  patches = [ ];

  dontBuild = true;

  # We dont need to patch nixpkgs shebang
  fixupPhase = ":";

  installPhase = ''
    mkdir -p $out
    cp -a .version * $out/
  '';

})
