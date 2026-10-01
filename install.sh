#!/usr/bin/env bash
# Install the Cursor CLI history sidecar into the current user's Omarchy config.
set -euo pipefail

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/bin"

usage() {
  cat <<'EOF'
Usage: ./install.sh

Copies bin/agent-history-view to ~/.config/omarchy/bin/.
Does not patch /usr/share/omarchy. You still need to paste the Lua
snippets into ~/.config/hypr/bindings.lua and hyprland.lua, then:

  hyprctl reload

See README.md.
EOF
  exit 2
}

for arg in "$@"; do
  case "$arg" in
    -h | --help) usage ;;
    *) usage ;;
  esac
done

install -Dm755 "$ROOT/bin/agent-history-view" "$DEST/agent-history-view"
echo "Installed $DEST/agent-history-view"
echo
echo "Add snippets/bindings.lua to ~/.config/hypr/bindings.lua"
echo "Add snippets/hyprland.lua to ~/.config/hypr/hyprland.lua"
echo "Then: hyprctl reload"
echo
echo "Optional: copy snippets/foot-agent.ini to ~/.config/foot/agent.ini"
echo "and launch Cursor CLI with --config=\$HOME/.config/foot/agent.ini"
