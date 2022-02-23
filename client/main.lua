local trafficLights = {
	0x3e2b73a4,
	0x336e5e2a,
	0xd8eba922,
	0xd4729f50,
	0x272244b2,
	0x33986eae,
	0x2323cdc5
}

if Config.QBCore then
	CreateThread(function()
		exports['qb-target']:AddTargetModel(trafficLights, {
			options = {
				{
					event = "pl-traffichack:startHack",
					icon = "fa-brands fa-usb",
					label = "Hack",
					item = 'phone',	--Replace with your own item
				},
			},
			distance = 1.2,
		})
	end)
end

if Config.QTarget then
	exports.qtarget:AddTargetModel(trafficLights, {
		options = {
			{
					event = "pl-traffichack:startHack",
					icon = "fa-brands fa-usb",
					label = "Hack",
					item = 'phone',	--Replace with your own item
			},
		},
		distance = 1.2
	})
end

function getLight()
    local coords = GetEntityCoords(PlayerPedId())
	for _, light in pairs(trafficLights) do
		local object = GetClosestObjectOfType(coords, 1.2, light, false, false, false)

		if object ~= 0 then
            -- We return the object, the hash and the coords to be able to get the object later on other clients
			return object, light, coords
		end
	end
end

function startAnim()
	local animDict = "amb@world_human_stand_mobile_fat@male@text@base"
	local animName = "base"

	RequestAnimDict(animDict)

	while not HasAnimDictLoaded(animDict) do
		Wait(1)
	end

	TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, 8.0, -1, 51)
end

RegisterNetEvent("pl-traffichack:startHack", function()
    -- getLight can return nil if it didn't find anything (shouldn't happen)
	local obj, light, coords = getLight()
    if obj == nil then return end
    
	startAnim()

	local success = exports['howdy-hackminigame']:Begin(2, 3000)

	if success then
        -- It seems that we can't use ObjToNet on obj because it is a local object and not a network object
		TriggerServerEvent("pl-traffichack:server:changeLights", light, coords)
	end

	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("pl-traffichack:changeLights")
AddEventHandler("pl-traffichack:changeLights", function(light, coords)
    -- There is no need to change it for players that are too far
    if #(GetEntityCoords(PlayerPedId()) - coords) > 150 then return end

    -- Try to get the object
    local obj = GetClosestObjectOfType(coords, 1.2, light, false, false, false)
    if obj == 0 then return end

	for i = 0, 3 do
		SetEntityTrafficlightOverride(obj, i)
		Wait(100)
	end

	SetEntityTrafficlightOverride(obj, 0)
	Wait(10000) --How long should it be green?
	SetEntityTrafficlightOverride(obj, 3)
end)
