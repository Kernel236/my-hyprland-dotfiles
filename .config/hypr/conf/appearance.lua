-- hyprland/conf/appearance.lua

-- Load active theme (symlink managed by theme-switch.sh)
-- dofile() re-reads on every reload — required for the symlink to work correctly
dofile(os.getenv("HOME") .. "/.config/hypr/theme.lua")

-- Layer rules: blur for floating overlay surfaces
-- swaync-notification-window (OSD popups) intentionally excluded: in 0.55+ blur applies
-- to the full surface area including transparent pixels, causing a full-height blur stripe
hl.layer_rule({ match = { namespace = "rofi"                  }, blur = true, animation = "fade" })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true, animation = "fade" })
hl.layer_rule({ match = { namespace = "wlogout"               }, blur = true, animation = "fade" })
