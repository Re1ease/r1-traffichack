RegisterNetEvent("pl-traffichack:server:changeLights")
AddEventHandler("pl-traffichack:server:changeLights", function()
	TriggerClientEvent("pl-traffichack:changeLights", -1)
end)