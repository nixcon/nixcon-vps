{
  pkgs ? import <nixpkgs> { },
  poetry2nix ? (import ../. { inherit pkgs; }).poetry2nix
}:

let
  default = poetry2nix.defaultPoetryOverrides;

  overrides = default // {
    # Pretalx is missing dependencies upstream
    pretalx = let
      overriden = self: super: drv: default.pretalx self super drv;
    in self: super: drv: drv.overrideAttrs(old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [
        pkgs.sass
      ];
    });

    static3 = self: super: drv: drv.overrideAttrs(old: {
      patches = [ ./static3.patch ];
    });

  };

in (poetry2nix.mkPoetryPackage {
  src = ./.;
  doCheck = false;
  inherit overrides;
}).overrideAttrs(old: {
  inherit (old.passthru.pythonPackages.pretalx) pname name version;
})
