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

  system.stateVersion = "18.09";
}
