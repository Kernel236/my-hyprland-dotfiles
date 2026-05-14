-- hyprland/conf/windowrules.lua
--
-- Sintassi: hl.window_rule({ name = "id", match = { ... }, opzione = valore })
--
-- match — criteri (tutti devono essere soddisfatti):
--   class      = "regex"    classe della finestra  (hyprctl clients → "class")
--   title      = "regex"    titolo della finestra  (hyprctl clients → "title")
--   xwayland   = true/false finestra XWayland
--   float      = true/false finestra floating
--   fullscreen = true/false finestra fullscreen
--   modal      = true/false dialogo modale
--   pin        = true/false finestra pinnata
--
-- Azioni disponibili:
--   float      = true            forza floating
--   tile       = true            forza tiled
--   fullscreen = true            forza fullscreen
--   center     = true            centra la finestra
--   size       = { w, h }        dimensione in px
--   move       = "x y"           posizione (px o %, "monitor_h-120" per bordi)
--   pin        = true            pinna la finestra (visibile su tutti i workspace)
--   no_focus   = true            non riceve focus automatico
--   no_max_size = true           ignora la dimensione massima dichiarata dall'app
--   min_size   = { w, h }        dimensione minima
--   opacity    = 0.9             opacità (o { active=1.0, inactive=0.8 })
--   workspace  = "n"             apre su workspace specifico
--   monitor    = "DP-1"          apre su monitor specifico
--   suppress_event = "maximize"  blocca eventi specifici dall'app

-- Suppress maximize requests from all windows
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix XWayland drag issues (blank floating xwayland windows)
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- hyprland-run: position at bottom-left
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- Burp Suite: main window (no max size, minimum usable size)
hl.window_rule({
    name        = "burpsuite-main",
    match       = { class = "^(burp-StartBurp)$" },
    no_max_size = true,
    min_size    = { 600, 400 },
})

-- Burp Suite: modal dialogs
hl.window_rule({
    name   = "burpsuite-dialogs-modal",
    match  = { class = "^(burp-StartBurp)$", modal = true },
    float  = true,
    center = true,
    size   = { 1100, 760 },
})

-- Burp Suite: named dialogs (Settings, Preferences, Options…)
hl.window_rule({
    name   = "burpsuite-dialogs-title",
    match  = {
        class = "^(burp-StartBurp)$",
        title = "^(.*Settings.*|.*Preferences.*|.*Options.*|.*Dialog.*)$",
    },
    float  = true,
    center = true,
    size   = { 1100, 760 },
})

-- Spotify: floating, comfortable size
hl.window_rule({
    name   = "spotify-float",
    match  = { class = "^(Spotify)$" },
    float  = true,
    size   = { 1100, 720 },
    center = true,
})

-- NetworkManager connection editor
hl.window_rule({
    name   = "nm-connection-editor-popup",
    match  = { class = "^(nm-connection-editor|Nm-connection-editor)$" },
    float  = true,
    center = true,
    size   = { 920, 640 },
})

-- Generic floating terminal tools
hl.window_rule({
    name   = "floating-terminal-tools",
    match  = { class = "^(floating-tool)$" },
    float  = true,
    center = true,
    size   = { 900, 620 },
})

-- Keybind cheat sheet: floating, pinned, centered
hl.window_rule({
    name   = "keybind-help",
    match  = { class = "^(keybind-help)$" },
    float  = true,
    center = true,
    size   = { 880, 840 },
    pin    = true,
})
