local array        = import '@Index/array'
local player       = import '@Index/player';
local statusModule = import '@iStatus/status';
local statusHud    = import 'status';
local statuses     = array.new()

local onUpdate     = function(status, val, max)
    status:set(val / max * 100)
end

for i = 1, #config.status do
    local data = config.status[i]
    local name = data.name
    local state, maxState = player.getState(name), player.getState("max:" .. name)
    local status = statusHud.new(name, state.get(), data.icon, data.styles, data.when and false or true)

    CreateThread(function()
        while not statusHud.isInit() do
            Wait(50)
        end

        local timeout = 0
        state.onChange(function(val, old)
            onUpdate(status, val, maxState.get())

            if (not data.when) then
                return
            end

            local percentage = val / maxState.get() * 100

            local function checkVisibility()
                if percentage <= data.when then
                    status.setVisibility(true)
                elseif timeout == 0 then
                    status.setVisibility(false)
                end
            end

            if percentage <= data.when then
                status.setVisibility(true)
                timeout = timeout + 1
                CreateThread(function()
                    Wait(5000)
                    timeout = timeout - 1
                    checkVisibility()
                end)
            else
                if (old < val) then
                    status.setVisibility(true)
                    timeout = timeout + 1
                    CreateThread(function()
                        Wait(5000)
                        timeout = timeout - 1
                        checkVisibility()
                    end)
                else
                    checkVisibility()
                end
            end
        end)
    end)
end
