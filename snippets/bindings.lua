-- Alt+H: Cursor CLI history sidecar.
-- Never call hyprctl from this callback (deadlocks the compositor).
-- Same-chord send_key_state would re-enter the bind, so non-agent
-- windows just ignore Alt+H.
o.bind("ALT + H", "Agent history", function()
  local window = hl.get_active_window()
  local class = window and window.class or ""
  if class == "org.omarchy.agent" or class == "org.omarchy.agent-history" then
    hl.dispatch(hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/omarchy/bin/agent-history-view"))
  end
end)
