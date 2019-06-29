{ pkgs, ... }:

{
  imports = [
    ../services/pretalx.nix
  ];

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

  services.redis.enable = true;

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

}
