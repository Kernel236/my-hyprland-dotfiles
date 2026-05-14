-- hyprland/conf/appearance.lua

-- Load active theme (symlink managed by theme-switch.sh)
-- dofile() re-reads on every reload — required for the symlink to work correctly
dofile(os.getenv("HOME") .. "/.config/hypr/theme.lua")

-- ── Layer rules ───────────────────────────────────────────────────────────────
-- Sintassi: hl.layer_rule({ match = { namespace = "nome" }, opzione = valore })
--
-- match può usare:
--   namespace = "stringa"   namespace della surface (vedi: hyprctl layers)
--   output    = "DP-1"      monitor specifico
--
-- Opzioni disponibili:
--   blur      = true/false   applica blur allo sfondo della surface
--   animation = "fade"       animazione: "fade" | "slide" | "slidevert" | "popin"
--   noanim    = true         disabilita animazione per questa surface
--   ignorealpha = 0.5        non applica blur sotto pixel con alpha < valore
--   xray      = true         blur vede attraverso layer trasparenti sopra
--
-- NOTA: swaync-notification-window (popup OSD) escluso intenzionalmente —
-- in Hyprland 0.55+ il blur si applica all'intera area inclusi pixel trasparenti,
-- causando una striscia verticale blur larga quanto la notifica su tutto lo schermo
hl.layer_rule({ match = { namespace = "rofi"                  }, blur = true, animation = "fade" })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true, animation = "fade" })
hl.layer_rule({ match = { namespace = "wlogout"               }, blur = true, animation = "fade" })
