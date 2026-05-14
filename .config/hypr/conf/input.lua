-- hyprland/conf/input.lua

hl.config({
    input = {
        -- Layout tastiera — esempi: "us", "it", "de", "fr"
        -- kb_variant per varianti: "intl" (us internazionale), "nodeadkeys" (it senza tasti morti)
        -- kb_options per combo: "grp:alt_shift_toggle" (alt+shift cambia layout)
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        -- follow_mouse: 0=focus solo click | 1=focus segue mouse | 2=focus+warp | 3=focus no warp
        follow_mouse = 1,
        -- sensitivity: -1.0 (lento) a 1.0 (veloce), 0 = default
        sensitivity  = 0,

        touchpad = {
            natural_scroll = true,   -- false = scroll classico (non invertito)
            -- tap_to_click   = true  -- tap sul touchpad = click sinistro
            -- disable_while_typing = true
        },
    },
})

-- ── Gesture touchpad ──────────────────────────────────────────────────────────
-- fingers:    numero di dita (3 o 4)
-- direction:  "horizontal" | "vertical"
-- action:     "workspace" (cambia workspace) | "fullscreen" | "changegroup"
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- ── Device specifico ──────────────────────────────────────────────────────────
-- Sovrascrive sensitivity per un dispositivo particolare.
-- Per trovare il nome: hyprctl devices
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})
