# Cursor CLI history sidecar for Omarchy

A **user-space companion** for [Omarchy](https://omarchy.org/) that opens a **read-only history pane** next to the [Cursor CLI](https://cursor.com/cli) (`cursor-agent` in Foot, `org.omarchy.agent`). The CLI composer stays where it is; you scroll the transcript in the sidecar. No patch to `/usr/share/omarchy`.

> **Built for Omarchy + Foot + Cursor CLI.** The CLI clears the terminal scrollback (`CSI 2J` / `CSI 3J`) and has no “pin composer” setting. This pane reads the conversation JSONL under `~/.cursor/projects/<abs-path-with-dashes>/agent-transcripts/` instead.

```
Alt+H on Cursor CLI     →  tiled Foot pane, last lines at the bottom
j / k / mouse wheel     →  scroll; follow the live transcript at the end
q or Alt+H again        →  close the sidecar
type in the CLI         →  still works — two windows, two buffers
```

This companion only *shows* history. It does not change Cursor, Foot’s default keymap, or Omarchy’s packaged Hyprland bindings.

---

### Support the Project
If this lets you read the log without losing the prompt, a tip is always appreciated.

[![Donate via PayPal](https://img.shields.io/badge/Donate-PayPal-blue.svg?style=for-the-badge&logo=paypal)](https://paypal.me/austraz)

---

### Feedback & Community
Got a question, found a bug, or have a suggestion? Open an [**issue**](https://github.com/austrasien/omarchy-cursor-cli-history/issues).

---

## Overview

Cursor CLI in a terminal cannot keep the input line stuck at the bottom while you scroll. Foot’s own scrollback is empty because the TUI wipes it. The real conversation is already on disk as JSONL.

| | Without | With this companion |
| :--- | :--- | :--- |
| **Scroll history** | Composer leaves the screen, or scrollback is empty | Sidecar pager; CLI stays on the prompt |
| **Read and type** | One buffer | Two windows on the same workspace |
| **Which chat** | Guess from the splash | JSONL Cursor actually has open (`store.db` UUID) |
| **Omarchy** | — | User-space only (`~/.config`) |

**Why not a plugin / hook / PR?** It is a Hyprland bind plus a Python pager. Omarchy has no plugin kind for that. A hook would run on `omarchy update`, not on `Alt+H`. Upstream Omarchy should not hard-code Cursor transcript paths.

## Key Features

### Transcript, not scrollback
- Discovers the focused Foot (`org.omarchy.agent`), walks to `cursor-agent`, slugs its cwd the same way Cursor does.
- Binds each live CLI window to the conversation UUID in `cursor-agent`’s open `store.db` (several CLIs in the same project no longer steal the newest JSONL).
- Renders the JSONL like the CLI: tool cards, compact diffs, quote gutter on unchanged lines, Ink-ish colors from the Omarchy theme.
- Reloads when the file grows. Short chats are **bottom-aligned** (last line sits on the row above the status bar).

### Hyprland bind, not a Foot key
- `Alt+H` is bound in `~/.config/hypr/bindings.lua` so it works on an **already-open** CLI window (Foot cannot add keys to a running instance).
- Uses `hl.get_active_window()`. **Never call `hyprctl` from the bind callback** — that deadlocks the compositor.
- Non-agent windows ignore `Alt+H` (do not `send_key_state` the same chord; it re-enters the bind).
- Sidecar class `org.omarchy.agent-history`: tiled next to the CLI (same Foot theme).

### Optional Foot profile
- `snippets/foot-agent.ini` turns off Foot scrollback for CLI windows only. Point `cursor-cli.desktop` at `--config=$HOME/.config/foot/agent.ini`.
- `snippets/foot-agent-history.ini` is the same palette for the sidecar (no extra top pad).

## Installation (Omarchy)

1. **Clone and install the script:**

   ```sh
   git clone https://github.com/austrasien/omarchy-cursor-cli-history.git
   cd omarchy-cursor-cli-history
   ./install.sh
   ```

   That copies `bin/agent-history-view` to `~/.config/omarchy/bin/`. It **never** overwrites `/usr/share/omarchy`.

2. **Paste the Lua snippets** into your user Hyprland config (create the files if they do not exist yet):

   - `snippets/bindings.lua` → `~/.config/hypr/bindings.lua`
   - `snippets/hyprland.lua` → `~/.config/hypr/hyprland.lua`

3. **Reload:**

   ```sh
   hyprctl reload
   ```

4. Focus a Cursor CLI window (`org.omarchy.agent`) and press **Alt+H**.

Python 3 with `curses` is required (`python` on Arch). `hyprctl` is used only **inside the pager process**, not from the bind.

### Optional: disable Foot scrollback for the CLI

```sh
install -Dm644 snippets/foot-agent.ini ~/.config/foot/agent.ini
```

Then launch Foot as:

```sh
foot --config="$HOME/.config/foot/agent.ini" --app-id=org.omarchy.agent
```

Optional sidecar ini:

```sh
install -Dm644 snippets/foot-agent-history.ini ~/.config/foot/agent-history.ini
```

Existing Foot windows keep the keymap they were started with.

## License

Licensed under the **MIT License**. Permissive for both personal and commercial use, provided attribution is maintained.

---
*Developed so you can read a Cursor CLI chat without losing the composer — without patching Omarchy.*
