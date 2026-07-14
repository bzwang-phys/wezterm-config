local wezterm = require("wezterm")
local platform = require("utils.platform")

local is_mac = platform().is_mac
local font = is_mac and "SF Mono Terminal" or "JetBrainsMono NF"
local font_size = is_mac and 20 or 13

return {
  font = wezterm.font(font),
  font_size = font_size,
  font_dirs = is_mac
      and { "/System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts" }
    or nil,

  --ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
  freetype_load_target = "Normal", ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
  freetype_render_target = "Normal", ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
