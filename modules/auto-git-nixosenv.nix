{
  config,
  pkgs,
  lib,
  ...
}:

let
  user = "qwerty";
  repoDir = "/home/${user}/NixOSenv";
  branch = "main"; # change to "master" if needed

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
        set -euo pipefail

        # Set anonymous identity ONLY for this commit
        git config --local user.name "Lysandercodes" || true
        git config --local user.email "lysander2006@proton.me" || true

        # Only commit if there is something to commit
        if git status --porcelain | grep -q .; then
          git add -A .
          git commit -m "Auto: changes in NixOSenv at $(date '+%Y-%m-%d %H:%M:%S')" || true
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

  # Push service – no need for identity here (push doesn't sign/author commits)
  systemd.user.services.auto-push-nixosenv = {
    description = "Push ~/NixOSenv to GitHub if there are unpushed commits";
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = repoDir;
      ExecStart = pkgs.writeShellScript "auto-push-nixosenv-exec" ''
        set -euo pipefail

        export GIT_SSH_COMMAND="ssh -i /home/${user}/.ssh/id_ed25519_anon -o IdentitiesOnly=yes"

        if git rev-list --count origin/${branch}..HEAD > /dev/null 2>&1 && \
           [ "$(git rev-list --count origin/${branch}..HEAD)" -gt 0 ]; then
          git push origin ${branch} || true
        fi
      '';
      User = user;
      Restart = "on-failure";
    };
  };

}
