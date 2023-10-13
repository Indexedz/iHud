local player   = import '@Index/player';
local behavior = player.behavior();
local player   = player.localPlayer();
local state    = player.getState("stamina");
local maxState = player.getState("max:stamina")

local config   = {
  name    = "stamina",
  visible = true,
  value   = state.get(),
  icon    = { "fas", "person-running" },
  styles  = {
    bar = "#7EAA92"
  }
}

local status   = import '@hud/status'.new(config.name, config.value, config.icon, config.styles, false);
local inWater  = false;
local maxVal   = maxState.get();

maxState.onChange(function (val)
  maxVal = val
end)

behavior.on("InWater", function()
  status.setVisibility(true)
  inWater = true
end, function()
  if (state.get() < maxVal) then
    return
  end
  inWater = false
  status.setVisibility(false)
end)

state.onChange(function(val)
  if (val < maxVal) then
    status.setVisibility(true)
  else
    CreateThread(function()
      Wait(2000)
      if (state.get() >= maxVal and not inWater) then
        status.setVisibility(false)
      end
    end)
  end

  status:set(val / maxVal * 100)
end)
