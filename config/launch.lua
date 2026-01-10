local platform = require("utils.platform")()

local options = {
  default_prog = {},
  launch_menu = {},
}

if platform.is_win then
  local wezterm = require("wezterm")
  local pwsh_cmd = "powershell"
  
  local success, stdout = wezterm.run_child_process({ "where", "pwsh" })
  if success and stdout and #stdout > 0 then
    pwsh_cmd = "pwsh"
  end
  
  options.default_prog = { pwsh_cmd }
  options.launch_menu = {
    { label = " PowerShell v1", args = { "powershell" } },
    { label = " PowerShell v7", args = { "pwsh" } },
    { label = " Cmd", args = { "cmd" } },
    { label = " Nushell", args = { "nu" } },
    {
      label = " GitBash",
      args = { "C:\\soft\\Git\\bin\\bash.exe" },
    },
    {
      label = " AlmaLinux",
      args = { "ssh", "kali@192.168.44.147", "-p", "22" },
    },
  }
elseif platform.is_mac then
  -- 检查fish是否可用，如果不可用则使用zsh作为备用
  local fish_path = "/usr/local/bin/fish"
  local fish_cmd = io.open(fish_path, "r") and fish_path or nil
  
  if fish_cmd then
    options.default_prog = { fish_cmd, "--login" }
  else
    options.default_prog = { "zsh", "--login" }
  end
  
  options.launch_menu = {
    { label = " Bash", args = { "bash", "--login" } },
    { label = " Fish", args = { "/usr/local/bin/fish", "--login" } },
    { label = " Nushell", args = { "/opt/homebrew/bin/nu", "--login" } },
    { label = " Zsh", args = { "zsh", "--login" } },
  }
elseif platform.is_linux then
  options.default_prog = { "bash", "--login" }
  options.launch_menu = {
    { label = " Bash", args = { "bash", "--login" } },
    { label = " Fish", args = { "/opt/homebrew/bin/fish", "--login" } },
    { label = " Nushell", args = { "/opt/homebrew/bin/nu", "--login" } },
    { label = " Zsh", args = { "zsh", "--login" } },
  }
end

return options
