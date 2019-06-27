{

  network.description = "Nixcon Nixops deployment";

  vps =
    { resources, ... }:
    {
      imports = [
        ./nixos/configuration.nix
      ];

      deployment.targetHost = "nixcon.martinmyska.cz";
    };

}
