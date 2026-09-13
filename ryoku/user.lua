local mod = "SUPER"
local _, rebinds = pcall(require, "rebinds")

local function K(k) return rebinds[k] or k end
local ws_helper = (os.getenv("HOME") or "") .. "/.config/hypr/scripts/ryoku-workspace"

hl.unbind(K(mod .. " + H"))
hl.unbind(K(mod .. " + ALT + H"))

for i = 1, 10 do
    local key = i % 10                                                                       -- 10 maps to the 0 key
    hl.bind(K(mod .. " + SHIFT + " .. key), hl.dsp.exec_cmd(ws_helper .. " move " .. i))     -- move window to workspace 1-10 on this desktop
    hl.bind(K(mod .. " + ALT + " .. key), hl.dsp.exec_cmd(ws_helper .. " movesilent " .. i)) -- move window silently to workspace 1-10 on this desktop
end

hl.window_rule({ match = { class = "^(vesktop|discord)$" }, workspace = "special:chat" })
hl.window_rule({ name = "float-spotify", match = { class = "[Ss]potify" }, workspace = "special:music", tile = true })

local specialWorkspaces = {
    chat  = { class = "vesktop", command = "vesktop" },
    music = { class = "Spotify", command = "spotify" },
}

local function toggleSpecial(name)
    local app = specialWorkspaces[name]
    return function()
        if #hl.get_windows({ class = app.class }) == 0 then
            hl.dispatch(hl.dsp.exec_cmd(app.command))
        end
        hl.dispatch(hl.dsp.workspace.toggle_special(name))
    end
end

hl.unbind("SUPER + M")
hl.bind("SUPER + D", toggleSpecial("chat"), { description = "Toggle chat special workspace" })
hl.bind("SUPER + M", toggleSpecial("music"), { description = "Toggle music special workspace" })

local screen_shader = os.getenv("HOME") .. "/.config/hypr/shaders/vibrance.glsl"

hl.config({
    decoration = {
        screen_shader = screen_shader,
    },
})
