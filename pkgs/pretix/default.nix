{
  pkgs ? import <nixpkgs> { },
  poetry2nix ? (import ../. { inherit pkgs; }).poetry2nix
}:

let
  overrides = poetry2nix.defaultPoetryOverrides // {
    django-oauth-toolkit = self: super: drv: drv.overrideAttrs(old:
    assert old.version == "1.2.0"; {
      # Upstream only provides a wheel and _only_ for 3.6...
      src = pkgs.fetchurl {
        url =  "https://files.pythonhosted.org/packages/3.6/d/django-oauth-toolkit/django_oauth_toolkit-1.2.0-py2.py3-none-any.whl";
        sha256 = old.src.outputHash;
      };
    });
  };

in (poetry2nix.mkPoetryPackage {
  src = ./.;
  doCheck = false;
  inherit overrides;
}).overrideAttrs(old: {
  inherit (old.passthru.pythonPackages.pretix) pname name version;
})
