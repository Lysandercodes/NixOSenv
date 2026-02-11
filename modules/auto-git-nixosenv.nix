# ~/.config/nixos/modules/auto-git-nixosenv.nix
{
  config,
  pkgs,
  lib,
  ...
}:

let
  user = "qwerty";
  repoDir = "/home/${user}/NixOSenv";
  branch = "main";
in
{
  environment.systemPackages = with pkgs; [
    inotify-tools
    git
    openssh
  ];

  # 1. Consolidated Sync Service (Commit + Push)
  systemd.user.services.auto-git-sync = {
    description = "Sync changes in ~/NixOSenv to GitHub";
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = repoDir;
      ExecStart = pkgs.writeShellScript "auto-git-sync-exec" ''
        #!/usr/bin/env bash
        set -euo pipefail

        GIT="${pkgs.git}/bin/git"
        SSH="${pkgs.openssh}/bin/ssh"

        export GIT_SSH_COMMAND="$SSH -i /home/${user}/.ssh/id_ed25519_anon -o IdentitiesOnly=yes"

        # Set identity for auto-commits
        $GIT config --local user.name "Lysandercodes" || true
        $GIT config --local user.email "lysander2006@proton.me" || true

        echo "--- Sync starting at $(date) ---"

        # Check for changes
        if $GIT status --porcelain | grep -q .; then
          echo "Changes detected. Committing..."
          $GIT add -A .
          $GIT commit -m "Auto: changes in NixOSenv at $(date '+%Y-%m-%d %H:%M:%S')" || true
        else
          echo "No local changes to commit."
        fi

        # Push if there are unpushed commits
        echo "Checking for unpushed commits..."
        $GIT fetch origin || { echo "Fetch failed, skipping push." >&2; exit 0; }

        AHEAD_COUNT=$($GIT rev-list --count origin/${branch}..HEAD 2>/dev/null || echo 0)
        if [ "$AHEAD_COUNT" -gt 0 ]; then
          echo "Pushing $AHEAD_COUNT commit(s) to origin/${branch}..."
          $GIT push origin ${branch} || { echo "Push failed." >&2; exit 0; }
          echo "Push successful."
        else
          echo "No commits to push."
        fi
        echo "--- Sync completed ---"
      '';
      User = user;
    };
  };

  # 2. Recursive File Watcher Service
  systemd.user.services.auto-git-watcher = {
    description = "Recursive watcher for ~/NixOSenv";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = pkgs.writeShellScript "auto-git-watcher-exec" ''
        #!/usr/bin/env bash
        set -euo pipefail

        WATCHER="${pkgs.inotify-tools}/bin/inotifywait"
        SYSTEMCTL="${pkgs.systemd}/bin/systemctl"

        echo "Starting recursive watch on ${repoDir}..."
        
        # Watch recursively (-r), exit on first event to trigger sync
        # Exclude .git directory to avoid infinite loops
        while true; do
          $WATCHER -r -e modify -e create -e delete -e move \
            --exclude "/\.git/" \
            "${repoDir}"
          
          echo "Change detected! Triggering sync..."
          $SYSTEMCTL --user start auto-git-sync.service
          
          # Coalesce rapid changes
          sleep 5
        done
      '';
      User = user;
      Restart = "always";
      RestartSec = "10s";
    };
  };
}
