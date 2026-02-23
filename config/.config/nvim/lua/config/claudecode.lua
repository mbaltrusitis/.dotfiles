return {
  -- mcp server configuration
  auto_start = true,
  port_range = { min = 10000, max = 65535 },
  log_level = "info",
  track_selection = true,
  visual_demotion_delay_ms = 10000, -- seconds

  -- claude cli runs in separate tmux pane and connects via mcp
  terminal = {
    provider = "none",
  },

  diff_opts = {
    layout = "vertical",
    open_in_new_tab = false,
  },
}
