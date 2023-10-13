local nui        = import '@hud/nui';
local vehicle    = import '@hud/vehicle';
local player     = import '@Index/player';
local behavior   = player.behavior();
local player     = player.localPlayer()

local directions = { N = 360, 0, NE = 315, E = 270, SE = 225, S = 180, SW = 135, W = 90, NW = 45, }
local seatbelt   = player.getState('seatbelt')

function getStreetLabel(coords)
  local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(),
    Citizen.ResultAsInteger())

  local zone = GetNameOfZone(coords.x, coords.y, coords.z)
  local hash1 = GetStreetNameFromHashKey(var1)
  local hash2 = GetStreetNameFromHashKey(var2)
  local heading = GetEntityHeading(PlayerPedId())

  for k, v in pairs(directions) do
    if (math.abs(heading - v) < 22.5) then
      heading = k;

      if (heading == 1) then
        heading = 'N';
        break;
      end

      break;
    end
  end

  local street2;
  if (hash2 == '') then
    street2 = GetLabelText(zone);
  else
    street2 = hash2 .. ', ' .. GetLabelText(zone);
  end

  return heading, street2, hash1;
end

function onVehicle()
  while true do
    local vehicle = GetVehiclePedIsIn(PlayerPedId())

    nui.send("UpdateVehicle", {
      seatbelt = seatbelt.get(),
      speed    = GetEntitySpeed(vehicle) * 3.6,
      fuel     = Entity(vehicle).state.fuel,
      health   = GetVehicleEngineHealth(vehicle) / 1000 * 100,
      address  = ("%s | %s %s"):format(getStreetLabel(GetEntityCoords(vehicle))),
    })

    Wait(500)
  end
end

behavior.on("InVehicle", function(...)
  vehicle.show()
  CreateThread(onVehicle)
end, function()
  vehicle.hide()
end)
