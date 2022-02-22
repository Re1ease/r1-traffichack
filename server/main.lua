RegisterNetEvent("pl-traffichack:server:changeLights")
AddEventHandler("pl-traffichack:server:changeLights", function(obj)
	TriggerClientEvent("pl-traffichack:changeLights", -1, obj)
end)
