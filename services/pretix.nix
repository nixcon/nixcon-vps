{ ... }:

let
  pkgs = import ./unstable.nix { };

  pretix = (import ../pkgs/pretix {
    inherit pkgs;
  });

  pythonPackages = pretix.passthru.pythonPackages;
  celery = pythonPackages.celery;
  gunicorn = pythonPackages.gunicorn;
  python = pythonPackages.python;

  name = "pretix";
  user = "pretix";
  server = {
    bind = "127.0.0.1";
    port = "8002";
  };

  environmentFile = pkgs.runCommand "pretix-environ" {
    buildInputs = [ pretix gunicorn celery ];  # Sets PYTHONPATH in derivation
  } ''
    cat > $out <<EOF
    PYTHONPATH=$PYTHONPATH
    EOF
  '';

  mkTimer = { description, unit, onCalendar }: {
    inherit description;
    requires = [ "pretix-migrate.service" ];
    after = [ "network.target" ];
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Persistent = true;
      OnCalendar = onCalendar;
      Unit = unit;
    };
  };


in {

  users.users."${user}" = {
    isNormalUser = false;
    createHome = true;
    home = "/var/pretix";
    description = "Pretix user";
  };

  environment.etc."pretix/pretix.cfg".source = ./pretix.cfg;

  systemd.services.pretix-migrate = {
    description = "Pretix DB Migrations";
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = environmentFile;
      User = user;
    };
    script = "${pretix}/bin/pretix migrate";
  };

  systemd.services.pretix-web = {
    description = "Pretix Web Service";
    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      EnvironmentFile = environmentFile;
      User = user;
      ExecStart = pkgs.writeScript "webserver" ''
        #!${pkgs.runtimeShell}
        set -euo pipefail
        exec ${gunicorn}/bin/gunicorn pretix.wsgi --name ${name} \
        --workers 3 \
        --log-level=info \
        --bind=${server.bind}:${server.port}
      '';
    };
    wantedBy = [ "multi-user.target" ];
    requires = [ "pretix-migrate.service" ];
    after = [ "network.target" ];
  };

  systemd.services.pretix-worker = {
    description = "Pretix Celery (Worker) Service";
    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      EnvironmentFile = environmentFile;
      User = user;
      ExecStart = "${celery}/bin/celery -A pretix.celery_app worker -l info";
    };
    wantedBy = [ "multi-user.target" ];
    requires = [ "pretix-migrate.service" ];
    after = [ "network.target" ];
  };

  systemd.services.pretix-runperiodic = {
    description = "Pretix periodic tasks";
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = environmentFile;
      User = user;
    };
    script = "${pretix}/bin/pretix runperiodic";
  };

  # Once every 5 minutes
  systemd.timers.pretix-runperiodic = mkTimer {
    description = "Run pretix tasks";
    unit = "pretix-runperiodic.service";
    onCalendar = "*:0/5";
  };

}
