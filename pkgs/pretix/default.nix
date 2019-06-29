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

      # For some reason the redirect url for django-oauth-toolkit doesnt work
      django-oauth-toolkit = self: super: drv: drv.overrideAttrs(old:
      assert old.version == "1.2.0"; {
        # Upstream only provides a wheel and _only_ for 3.6...
        src = pkgs.fetchurl {
          url =  "https://files.pythonhosted.org/packages/3.6/d/django-oauth-toolkit/django_oauth_toolkit-1.2.0-py2.py3-none-any.whl";
          sha256 = old.src.outputHash;
        };
      });

    };

  in poetry2nix.mkPoetryPackage {
    src = ./.;
    inherit overrides;
  };

in wrapper.passthru.pythonPackages
