local player   = import '@Index/player';
local behavior = import '@Index/behavior';
local state    = player.getState("oxygen")
local maxState = player.getState("max:oxygen")
local config   = {
    name    = "oxygen",
    visible = false,
    value   = state.get(),
    icon    = { "fas", "person-swimming" },
    styles  = {
        bar = "#7EAA92"
    }
}

local status   = import 'status'.new(config.name, config.value, config.icon, config.styles, config.visible);
local inWater  = false;
behavior.on("InWater", function()
    status.setVisibility(true)
    inWater = true
end, function()
    if (state.get() < maxState.get()) then
        return
    end
    inWater = false
    status.setVisibility(false)
end)

state.onChange(function(val)
    if (val >= maxState.get()) then
        CreateThread(function()
            Wait(2000)
            if (state.get() >= maxState.get() and not inWater) then
                status.setVisibility(false)
            end
        end)
    else
        status.setVisibility(true)
    end

    status:set(val / maxState.get() * 100)
end)
