local module = {}
local ready  = false

CreateThread(function()
  Wait(2000)
  ready = true
end)

function module.send(header, props)
  if not ready then
    while not ready do
      Wait(100)
    end
  end

  SendNUIMessage({
    header = header,
    props = props
  })
end

return module
