-- hyprland/conf/keybinds.lua

local home    = os.getenv("HOME")
local mainMod = "SUPER"

local terminal    = "kitty"
local fileManager = "yazi"
local browser     = "firefox"
local notes       = "obsidian"
local editor      = "code"
local editorAlt   = "subl"
local colorPicker = "hyprpicker"
local menu        = home .. "/.local/bin/rofi-launcher -show drun -modi 'drun,window,clipboard:" .. home .. "/.local/bin/rofi-clipboard'"

-- App launches
hl.bind(mainMod .. " + T",           hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B",           hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + B",   hl.dsp.exec_cmd("firefox -P pentest --no-remote"))
hl.bind(mainMod .. " + O",           hl.dsp.exec_cmd(notes))
hl.bind(mainMod .. " + V",           hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + ALT + V",     hl.dsp.exec_cmd(editorAlt))
hl.bind(mainMod .. " + F",           hl.dsp.exec_cmd(terminal .. " " .. fileManager))
hl.bind(mainMod .. " + A",           hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P",           hl.dsp.exec_cmd("sh -c '" .. colorPicker .. " | wl-copy'"))
hl.bind(mainMod .. " + SHIFT + P",   hl.dsp.exec_cmd(home .. "/.config/waybar/scripts/idle-toggle.sh"))
hl.bind(mainMod .. " + SHIFT + A",   hl.dsp.exec_cmd(home .. "/.local/bin/rofi-launcher -show emoji"))

-- Wallpaper picker
hl.bind(mainMod .. " + SHIFT + W",   hl.dsp.exec_cmd(home .. "/.local/bin/rofi-wallpaper"))

-- Kill window
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- Float preset: minimize (1100x720 centered) / maximize (1500x820 centered)
hl.bind(mainMod .. " + M", function()
    hl.dispatch(hl.dsp.window.resize({ x = 1100, y = 720, relative = false }))
    hl.dispatch(hl.dsp.window.center())
end)
hl.bind(mainMod .. " + SHIFT + M", function()
    hl.dispatch(hl.dsp.window.resize({ x = 1500, y = 820, relative = false }))
    hl.dispatch(hl.dsp.window.center())
end)

-- Toggle float / fullscreen
hl.bind(mainMod .. " + W",           hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F",   hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + ALT + F",     hl.dsp.window.fullscreen({ mode = "maximized",  action = "toggle" }))

-- Layout toggle (dwindle)
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Center floating window
hl.bind(mainMod .. " + SPACE", hl.dsp.window.center())

-- Alt-Tab: cycle windows (prev/next) and bring to top
hl.bind("ALT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
    hl.dispatch(hl.dsp.window.bring_to_top())
end)
hl.bind("ALT + SHIFT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- Focus with arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down"  }))

-- Move window in layout (arrows + vim)
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left"  }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up"    }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down"  }))
hl.bind(mainMod .. " + SHIFT + H",     hl.dsp.window.move({ direction = "left"  }))
hl.bind(mainMod .. " + SHIFT + L",     hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K",     hl.dsp.window.move({ direction = "up"    }))
hl.bind(mainMod .. " + SHIFT + J",     hl.dsp.window.move({ direction = "down"  }))

-- Resize with CTRL + arrows + vim (repeating)
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x =  30, y =   0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.resize({ x = -30, y =   0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.resize({ x =   0, y = -30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.resize({ x =   0, y =  30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + L",     hl.dsp.window.resize({ x =  30, y =   0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + H",     hl.dsp.window.resize({ x = -30, y =   0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + K",     hl.dsp.window.resize({ x =   0, y = -30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + J",     hl.dsp.window.resize({ x =   0, y =  30, relative = true }), { repeating = true })

-- Mouse drag / resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + Z",        hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + X",        hl.dsp.window.resize(), { mouse = true })

-- Workspace: switch (SUPER + 1-0)
-- Move window + follow (SUPER + SHIFT + 1-0)
-- Move window silently (SUPER + CTRL + 1-0)
for i = 1, 10 do
    local key = i % 10  -- 10 → key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. key,      hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Scratchpad (special workspace)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Cycle workspaces with SUPER + TAB / SUPER + SHIFT + TAB
hl.bind(mainMod .. " + Tab",         hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "previous" }))

-- Scroll through workspaces with mouse wheel
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Lock / logout
hl.bind(mainMod .. " + L",      hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd(
    "wlogout -p layer-shell" ..
    " -C " .. home .. "/.config/wlogout/style.css" ..
    " -l " .. home .. "/.config/wlogout/layout" ..
    " -b 5"
))

-- Waybar toggle
hl.bind("CTRL + ESCAPE", hl.dsp.exec_cmd("sh -c 'killall waybar || waybar'"))

-- Screenshots
hl.bind(            "Print",              hl.dsp.exec_cmd("grimblast --notify copysave screen"))
hl.bind(mainMod .. " + Print",           hl.dsp.exec_cmd("grimblast --notify copysave active"))
hl.bind(mainMod .. " + ALT + Print",     hl.dsp.exec_cmd("grimblast --notify copysave area"))
hl.bind(mainMod .. " + SHIFT + Print",   hl.dsp.exec_cmd(
    "sh -c 'grimblast save area /tmp/swappy-screenshot.png && swappy -f /tmp/swappy-screenshot.png'"
))

-- Volume (locked = works on lock screen too)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/osd-volume up"),   { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/osd-volume down"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/osd-volume mic"),  { locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/osd-volume mute"), { locked = true })

-- Media keys
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/osd-brightness up"),   { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/osd-brightness down"), { locked = true })

-- Notification center toggle
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t"))

-- Keybind cheat sheet
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(
    "kitty --class keybind-help --override font_size=10 -e " ..
    home .. "/.config/hypr/scripts/keybind-help.sh"
))

-- Theme switch
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.exec_cmd(home .. "/.config/waybar/scripts/theme-switch.sh matrix"))
hl.bind(mainMod .. " + CTRL + I",  hl.dsp.exec_cmd(home .. "/.config/waybar/scripts/theme-switch.sh macchiato"))
