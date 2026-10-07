-- Agent history: tile beside Cursor CLI. Strip +terminal from org.omarchy.*
-- (terminals.lua) so the sidecar stays a normal tiled pane.
o.window("org.omarchy.agent-history", {
  tag = "-terminal",
  tile = true,
  float = false,
})
