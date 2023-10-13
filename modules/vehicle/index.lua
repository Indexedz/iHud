local module   = {}
local player   = import '@Index/player';
local nui      = import 'nui';

local visible  = false

function module.show()
  if visible then
    return
  end

  visible = true
  nui.send("SetVisibleVehicle", true)
end

function module.hide()
  if not visible then
    return
  end

  visible = false
  nui.send("SetVisibleVehicle", false)
end

return module
