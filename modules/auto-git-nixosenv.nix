{
  config,
  pkgs,
  lib,
  ...
}:

let
  user = "qwerty";
  repoDir = "/home/${user}/NixOSenv";
  branch = "main"; # change to "master" if your default branch is different
in
{
  environment.systemPackages = with pkgs; [
    inotify-tools
    git
  ];

  # Commit service – runs on file changes
  systemd.user.services.auto-commit-nixosenv = {
    description = "Auto-commit changes in ~/NixOSenv";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = repoDir;
      ExecStart = pkgs.writeShellScript "auto-commit-nixosenv-exec" ''
        #!/usr/bin/env bash
        set -euo pipefail

        GIT="${pkgs.git}/bin/git"

        # Set anonymous identity ONLY for this commit
        $GIT config --local user.name "Lysandercodes" || true
        $GIT config --local user.email "lysander2006@proton.me" || true

        # Only commit if there is something to commit
        if $GIT status --porcelain | grep -q .; then
          $GIT add -A .
          $GIT commit -m "Auto: changes in NixOSenv at $(date '+%Y-%m-%d %H:%M:%S')" || true
        fi
      '';
      User = user;
      Restart = "on-failure";
    };
  };

  # Path unit – triggers commit on file change
  systemd.user.paths.auto-commit-nixosenv-trigger = {
    description = "Watch ~/NixOSenv for changes";
    wantedBy = [ "default.target" ];
    pathConfig = {
      PathModified = repoDir;
      Unit = "auto-commit-nixosenv.service";
    };
  };

  # Timer for periodic push
  systemd.user.timers.auto-push-nixosenv = {
    description = "Periodic push of NixOSenv to GitHub";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "10min";
      Unit = "auto-push-nixosenv.service";
      Persistent = true;
    };
  };

  # Push service
  systemd.user.services.auto-push-nixosenv = {
    description = "Push ~/NixOSenv to GitHub if there are unpushed commits";
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = repoDir;
      ExecStart = pkgs.writeShellScript "auto-push-nixosenv-exec" ''
        #!/usr/bin/env bash
        set -euo pipefail

        GIT="${pkgs.git}/bin/git"

        export GIT_SSH_COMMAND="ssh -i /home/${user}/.ssh/id_ed25519_anon -o IdentitiesOnly=yes"

        if $GIT rev-list --count origin/${branch}..HEAD > /dev/null 2>&1 && \
           [ "$($GIT rev-list --count origin/${branch}..HEAD)" -gt 0 ]; then
          $GIT push origin ${branch} || true
        fi
      '';
      User = user;
      Restart = "on-failure";
    };
  };
}
