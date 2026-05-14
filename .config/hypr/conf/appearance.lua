-- hyprland/conf/appearance.lua

-- Load active theme (symlink managed by theme-switch.sh)
-- dofile() re-reads on every reload — required for the symlink to work correctly
dofile(os.getenv("HOME") .. "/.config/hypr/theme.lua")

-- Layer rules: blur for floating overlay surfaces
hl.layer_rule({ match = { namespace = "rofi"                       }, blur = true })
hl.layer_rule({ match = { namespace = "swaync-control-center"      }, blur = true })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true })
hl.layer_rule({ match = { namespace = "wlogout"                    }, blur = true })
