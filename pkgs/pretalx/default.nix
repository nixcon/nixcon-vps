{
  pkgs ? import <nixpkgs> { },
  poetry2nix ? (import ../. { inherit pkgs; }).poetry2nix
}:

let

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
          pkgs.sass
        ];

        # TODO: Migrate away from this pattern of modifying the pretalx package
        # Our "wrapper" package could contain bin outputs that are entry points instead
        propagatedBuildInputs = old.propagatedBuildInputs ++ [
          self.psycopg2-binary
          self.django-redis
          self.dj-static
        ];

      });

      static3 = self: super: drv: drv.overrideAttrs(old: {
        patches = [ ./static3.patch ];
      });

    };

  in poetry2nix.mkPoetryPackage {
    src = ./.;
    inherit overrides;
  };

in wrapper.passthru.pythonPackages
