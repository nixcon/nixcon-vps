{ config, pkgs, ... }:
{
  imports = [
          <nixpkgs/nixos/modules/profiles/minimal.nix>
          <nixpkgs/nixos/modules/virtualisation/container-config.nix>
          <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
          ./build.nix
          ./networking.nix
          ./custom.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  time.timeZone = "Europe/Amsterdam";

  documentation.enable = true;
  services.nixosManual.enable = true;
  # in 19.03 change services.nixosManual.enable to documentation.nixos.enable = true;

  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE pretalx WITH LOGIN PASSWORD 'pretalx' CREATEDB;
      CREATE DATABASE pretalx;
      GRANT ALL PRIVILEGES ON DATABASE pretalx TO pretalx;
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.caddy = {
    enable = true;
    agree = true;
    config = ''
      cfp.nixcon.org {
        gzip
        proxy / localhost:8001 {
          transparent
        }
      }
    '';
  };

  system.stateVersion = "18.09";
}
