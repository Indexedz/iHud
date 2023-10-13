local state = import '@Index/player'.localPlayer().getState("health");
local config = {
  name    = "health",
  visible = true,
  value   = state.get() - 100,
  icon    = { "fas", "heart" },
  styles  = {
    bar = "#7EAA92"
  }
}

local status = import '@hud/status'.new(config.name, config.value, config.icon, config.styles, config.visible);
state.onChange(function(val)
  status:set(val-100)
end)

