local player   = import '@Index/player';
local event    = import '@Index/event';
local status   = import 'status';

local invState = player.getState("InventoryState");
local function onPlayerLoaded()
    Wait(2000)
    status.start()
end

local function onInventoryStateChanged(state)
    status.setForceVisible(state == true and { 'hunger', 'thirst' } or {})
end

invState.onChange(onInventoryStateChanged)
event.onStart(onPlayerLoaded)
player.on("loaded", onPlayerLoaded)
