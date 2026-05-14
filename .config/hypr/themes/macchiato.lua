-- hyprland/themes/macchiato.lua

hl.config({
    general = {
        gaps_in  = 2,   -- gap tra finestre adiacenti (px)
        gaps_out = 5,   -- gap tra finestre e bordo monitor (px)

        border_size = 2,  -- spessore bordo finestre (px)

        -- col.active_border: colore bordo finestra attiva
        --   stringa singola:  "rgba(rrggbbaa)"
        --   gradiente:        { colors = { "rgba(...)", "rgba(...)" }, angle = 45 }
        col = {
            active_border   = { colors = { "rgba(b7bdf8ff)", "rgba(8aadf4ff)" }, angle = 45 },
            inactive_border = "rgba(363a4faa)",
        },

        resize_on_border = true,   -- trascina il bordo per ridimensionare
        allow_tearing    = false,  -- abilita tearing (riduce latenza, rovina vsync)
        -- layout: "dwindle" (spirale) | "master" (master-stack)
        layout           = "dwindle",
    },

    decoration = {
        rounding = 5,  -- arrotondamento angoli finestre (px, 0 = niente)

        active_opacity   = 1.0,   -- opacità finestra attiva  (0.0-1.0)
        inactive_opacity = 0.75,  -- opacità finestre inattive

        blur = {
            enabled        = true,
            size           = 6,      -- raggio blur (più alto = più sfocato, più pesante)
            passes         = 2,      -- passaggi blur (più alto = più smooth, più pesante)
            vibrancy       = 0.1696, -- saturazione colori sotto il blur (0.0-1.0)
            ignore_opacity = false,  -- true = blur anche su finestre opache
            xray           = true,   -- true = blur vede attraverso layer trasparenti
        },
    },

    animations = { enabled = true },  -- false = disabilita tutte le animazioni

    dwindle = {
        preserve_split = true,  -- mantiene direzione split quando sposti finestre
        -- pseudotile = true   -- finestre tiled con dimensione fissa (come floating in layout)
    },

    misc = {
        force_default_wallpaper  = 0,     -- 0 = usa il tuo wallpaper
        disable_hyprland_logo    = true,  -- rimuove logo hyprland al centro
        disable_splash_rendering = true,  -- rimuove splash screen
        vrr                      = 0,     -- Variable Refresh Rate: 0=off 1=on 2=solo fullscreen
        size_limits_tiled        = true,  -- rispetta min/max size anche in layout tiled
    },
})

-- ── Curve bezier ──────────────────────────────────────────────────────────────
-- Sintassi: hl.curve("nome", { type = "bezier", points = { {x1,y1}, {x2,y2} } })
-- Tool visuale per disegnare curve: https://cubic-bezier.com
--
-- Preset utili da copiare:
--   easeOut  (decelerazione):   { { 0.05, 0.9  }, { 0.1,  1.0  } }
--   easeIn   (accelerazione):   { { 0.9,  0.0  }, { 1.0,  0.0  } }
--   overShoot (rimbalzo):       { { 0.05, 0.9  }, { 0.1,  1.1  } }
--   linear   (costante):        { { 1.0,  1.0  }, { 1.0,  1.0  } }
--   snap     (immediato+ease):  { { 0.1,  1.0  }, { 0.1,  1.0  } }
hl.curve("wind",   { type = "bezier", points = { { 0.05, 0.9  }, { 0.1,  1.05 } } })
hl.curve("winIn",  { type = "bezier", points = { { 0.1,  1.1  }, { 0.1,  1.1  } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3  }, { 0.0,  1.0  } } })
hl.curve("liner",  { type = "bezier", points = { { 1.0,  1.0  }, { 1.0,  1.0  } } })

-- ── Animazioni ────────────────────────────────────────────────────────────────
-- Sintassi: hl.animation({ leaf = "evento", enabled = bool, speed = n, bezier = "nome", style = "stile" })
-- speed: in decimi di secondo (5 = 500ms, 10 = 1s)
--
-- Leaf (eventi):
--   windows / windowsIn / windowsOut / windowsMove
--   layers / layersIn / layersOut
--   fade / fadeIn / fadeOut / fadeSwitch / fadeShadow / fadeDim
--   border / borderangle
--   workspaces / specialWorkspace
--
-- Style per windows e layers:
--   "slide"     scivola dal bordo dello schermo
--   "slidevert" scivola verticalmente
--   "popin"     zoom dal centro (prende % opzionale: style="popin 80%")
--   "fade"      dissolvenza pura
--
-- Style per workspaces:
--   "slide"       scorre orizzontalmente
--   "slidevert"   scorre verticalmente
--   "fade"        dissolvenza
--   "slidefade"   slide + fade insieme
--
-- Style per borderangle:
--   "loop"  rotazione continua del gradiente sul bordo
hl.animation({ leaf = "windows",      enabled = true, speed = 6,  bezier = "wind",   style = "slide" })
hl.animation({ leaf = "windowsIn",    enabled = true, speed = 6,  bezier = "winIn",  style = "slide" })
hl.animation({ leaf = "windowsOut",   enabled = true, speed = 5,  bezier = "winOut", style = "slide" })
hl.animation({ leaf = "windowsMove",  enabled = true, speed = 5,  bezier = "wind",   style = "slide" })
hl.animation({ leaf = "border",       enabled = true, speed = 1,  bezier = "liner" })
hl.animation({ leaf = "borderangle",  enabled = true, speed = 30, bezier = "liner",  style = "loop" })
hl.animation({ leaf = "fade",         enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "workspaces",   enabled = true, speed = 5,  bezier = "wind" })
