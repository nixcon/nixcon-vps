{ pkgs ? import <nixpkgs> { } }:

let
  poetry2nix = import (pkgs.fetchFromGitHub {
    owner = "adisbladis";
    repo = "poetry2nix";
    rev = "2751fd970778b3280b666e24fda8ed5fa4773e4a";
    sha256 = "0r581dfr2n7hkjx4n4hsanhv1wciqqabd1pcwqsmcznr5nxzldsh";
  }) { inherit pkgs; };

  # Provide a dummy wrapper so the update behaviour of
  # the entire env is `poetry install`
  wrapper = let
    default = poetry2nix.defaultPoetryOverrides;

    overrides = default // {
      # Pretalx is missing dependencies upstream
      pretalx = let
        overriden = self: super: drv: default.pretalx self super drv;
      in self: super: drv: drv.overrideAttrs(old: {

        nativeBuildInputs = old.nativeBuildInputs ++ [
          pkgs.gettext
          pkgs.sass
        ];

        propagatedBuildInputs = old.propagatedBuildInputs ++ [
          self.psycopg2-binary
          self.dj-static
        ];

      });

      psycopg2-binary = self: super: drv: drv.overrideAttrs(old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.postgresql ];
      });
    };

  in poetry2nix.mkPoetryPackage {
    src = ./.;
    inherit overrides;
  };

in wrapper.passthru.pythonPackages
