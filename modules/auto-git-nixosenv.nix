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
    autocommit
    git
    openssh
  ];

  # 1. Autocommit Service
  systemd.user.services.auto-git-autocommit = {
    description = "AI-powered Autocommit for ~/NixOSenv";
    wantedBy = [ "default.target" ];

    # We use an EnvironmentFile to store the API key securely.
    # The user should create this file at ~/.config/autocommit/secrets.env
    # with the content: AUTOCOMMIT_API_KEY=sk-...
    serviceConfig = {
      EnvironmentFile = "-%h/.config/autocommit/secrets.env";
      WorkingDirectory = repoDir;
      ExecStart = pkgs.writeShellScript "autocommit-wrapper" ''
        #!/usr/bin/env bash
        set -euo pipefail

        GIT="${pkgs.git}/bin/git"
        SSH="${pkgs.openssh}/bin/ssh"

        # Export SSH key for git operations
        export GIT_SSH_COMMAND="$SSH -i /home/${user}/.ssh/id_ed25519_anon -o IdentitiesOnly=yes"

        # Set local git identity for this repo
        cd "${repoDir}"
        $GIT config --local user.name "Lysandercodes"
        $GIT config --local user.email "lysander2006@proton.me"

        # Create a temporary config.yaml that includes the API key from environment
        CONFIG_DIR=$(mktemp -d)
        trap 'rm -rf "$CONFIG_DIR"' EXIT

        # Default values or override via environment
        BASE_URL=''${AUTOCOMMIT_BASE_URL:-"https://api.openai.com/v1/"}
        MODEL=''${AUTOCOMMIT_MODEL:-"gpt-4o"}
        PUSH=''${AUTOCOMMIT_PUSH:-"true"}
        INTERVAL=''${AUTOCOMMIT_INTERVAL:-"30"}

        cat > "$CONFIG_DIR/config.yaml" <<EOF
repo_path: "${repoDir}"
interval_seconds: $INTERVAL
api_key: "$AUTOCOMMIT_API_KEY"
base_url: "$BASE_URL"
push: $PUSH
model: "$MODEL"
timeout: 30
EOF

        # Run the autocommit tool
        cd "$CONFIG_DIR"
        exec ${pkgs.autocommit}/bin/autocommit
      '';
      Restart = "always";
      RestartSec = "10s";
    };
  };
}
