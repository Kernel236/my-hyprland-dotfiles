-- hyprland/themes/matrix.lua
-- Stesse opzioni di macchiato.lua — vedi i commenti lì per la reference completa.

hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = 6,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(ff4455ff)", "rgba(ff8040ff)" }, angle = 45 },
            inactive_border = "rgba(1e0606cc)",
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding = 1,

        active_opacity   = 1.0,
        inactive_opacity = 0.82,

        blur = {
            enabled        = true,
            size           = 5,
            passes         = 2,
            vibrancy       = 0.09,
            ignore_opacity = false,
            xray           = true,
        },
    },

    animations = { enabled = true },

    dwindle = { preserve_split = true },

    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        vrr                      = 0,
        size_limits_tiled        = true,
    },
})

-- Curve più snappy rispetto a macchiato: meno rimbalzo, più secco
hl.curve("wind",   { type = "bezier", points = { { 0.08, 0.86 }, { 0.12, 1.0  } } })
hl.curve("winIn",  { type = "bezier", points = { { 0.12, 0.98 }, { 0.12, 1.0  } } })
hl.curve("winOut", { type = "bezier", points = { { 0.22, 0.0  }, { 0.0,  1.0  } } })
hl.curve("liner",  { type = "bezier", points = { { 1.0,  1.0  }, { 1.0,  1.0  } } })

hl.animation({ leaf = "windows",      enabled = true, speed = 5,  bezier = "wind",   style = "slide" })
hl.animation({ leaf = "windowsIn",    enabled = true, speed = 5,  bezier = "winIn",  style = "slide" })
hl.animation({ leaf = "windowsOut",   enabled = true, speed = 4,  bezier = "winOut", style = "slide" })
hl.animation({ leaf = "windowsMove",  enabled = true, speed = 4,  bezier = "wind",   style = "slide" })
hl.animation({ leaf = "border",       enabled = true, speed = 1,  bezier = "liner" })
hl.animation({ leaf = "borderangle",  enabled = true, speed = 24, bezier = "liner",  style = "loop" })
hl.animation({ leaf = "fade",         enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "workspaces",   enabled = true, speed = 4,  bezier = "wind" })
