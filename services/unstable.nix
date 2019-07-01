let
  src = builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs-channels/archive/nixos-unstable.tar.gz";
  };

  pkgs = import src { };

in import (pkgs.stdenv.mkDerivation {
  name = "nixpkgs";

  inherit src;

  patches = [
    # Downgrade overmind
    (pkgs.fetchpatch {
      url = "https://github.com/NixOS/nixpkgs/commit/8df753c5983cdd4ca9b454570c7987feba8ebb2a.patch";
      sha256 = "0rihi009a6scg60jqj3dssh4qszgyyzngm1zglci21bc7a1gmd19";
    })
  ];

  dontBuild = true;

  # We dont need to patch nixpkgs shebang
  fixupPhase = ":";

  installPhase = ''
    mkdir -p $out
    cp -a .version * $out/
  '';

})
