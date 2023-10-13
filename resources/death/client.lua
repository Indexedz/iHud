local state = import '@Index/player'.localPlayer().getState("death");
local config = {
    name    = "death",
    visible = false,
    value   = state.get(),
    icon    = { "fas", "skull" },
    styles  = {
        bar = "#7EAA92"
    }
}

local status = import '@hud/status'.new(config.name, config.value, config.icon, config.styles, config.visible);

state.onChange(function (val)
    local visiblity = val >= 1 and true or false;

    status:set(val)
    status.setVisibility(visiblity)
end)

