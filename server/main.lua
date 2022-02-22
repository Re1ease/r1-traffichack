RegisterNetEvent("pl-traffichack:server:changeLights")
AddEventHandler("pl-traffichack:server:changeLights", function(light, coords)
	TriggerClientEvent("pl-traffichack:changeLights", -1, light, coords)
end)
