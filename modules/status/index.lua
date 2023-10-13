local array    = import '@Index/array';
local nui      = import '@hud/nui';

local status   = array.new();
local requests = array.new();
local visible  = false;
local module   = {}

local init     = false;

CreateThread(function()
    while true do
        Wait(100)

        if (#requests > 0) then
            local mergedRequests = {}
            local processedNames = {}

            for i, request in ipairs(requests) do
                local name = request.name

                if not processedNames[name] then
                    local mergedRequest = { name = name }
                    local iconSet = false

                    for j, req in ipairs(requests) do
                        if req.name == name then
                            if not iconSet and req.icon then
                                mergedRequest.icon = req.icon
                                iconSet = true
                            end

                            if req.visible ~= nil then
                                mergedRequest.visible = req.visible
                            end

                            if req.percentage then
                                mergedRequest.percentage = (mergedRequest.percentage or 0) + req.percentage
                            end
                        end
                    end

                    processedNames[name] = true
                    table.insert(mergedRequests, mergedRequest)
                end
            end

            nui.send("UpdateStatus", mergedRequests)
            requests:clear()
        end
    end
end)

function module.find(name)
    return status:find(function(status)
        return status.name == name
    end)
end

function module.new(name, default, icon, colours, visible)
    local add = function(name, default, icon, colours, visible)
        if (module.find(name)) then
            return error("already have status : " .. name)
        end

        local self = {}
        local visible = visible
        self.id = name;

        nui.send("CreateStatus", {
            {
                percentage = default,
                icon       = icon,
                visible    = visible,
                name       = name,
                color      = colour
            }
        })

        function self:set(val, icon)
            return requests:push({
                name = self.id,
                percentage = val,
                icon = icon,
                visible = visible
            })
        end

        function self.setVisibility(state)
            if (visible == state) then
                return
            end

            visible = state
            return requests:push({
                name = self.id,
                visible = visible
            })
        end

        status:push(self)
        return self;
    end

    if type(name) == "table" then
        local results = {}
        for i = 1, #name do
            table.insert(results, add(name[i][1], name[i][2], name[i][3], name[i][4], name[i][5]))
        end

        return results
    else
        return add(name, default, icon, colours, visible)
    end
end

function module.show()
    if visible then
        return
    end

    if (IsPauseMenuActive()) then
        return
    end

    visible = true
    nui.send("SetVisibleStatus", true)
end

function module.hide()
    if not visible then
        return
    end

    visible = false
    nui.send("SetVisibleStatus", false)
end

function module.start()
    init = true

    CreateThread(function()
        while true do
            Wait(100)

            if (IsPauseMenuActive() and visible) then
                module.hide()
            elseif (not IsPauseMenuActive() and not visible) then
                module.show()
            end
        end
    end)
end

function module.setForceVisible(boolean)
    nui.send("SetForceVisibility", boolean)
end

function module.isInit()
    return init
end

return module
