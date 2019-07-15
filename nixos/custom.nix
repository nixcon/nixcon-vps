{ pkgs, ... }:

{
  imports = [
    ../services/pretalx.nix
    ../services/pretix.nix
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

      CREATE ROLE pretix WITH LOGIN PASSWORD 'pretix' CREATEDB;
      CREATE DATABASE pretix;
      GRANT ALL PRIVILEGES ON DATABASE pretix TO pretix;
    '';
  };

  services.redis.enable = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts."cfp.nixcon.org" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:8001";
      };
    };
    virtualHosts."tickets.nixcon.org" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:8002";
      };
    };
  };

}
