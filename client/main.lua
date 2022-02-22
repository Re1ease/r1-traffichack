local trafficLights = {
	0x3e2b73a4,
	0x336e5e2a,
	0xd8eba922,
	0xd4729f50,
	0x272244b2,
	0x33986eae,
	0x2323cdc5
}

local object = 0

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

function getLight()
	for _, light in pairs(trafficLights) do
		object = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.2, light, false, false, false)

		if object ~= 0 then
			return object
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
	getLight()
	startAnim()

	local success = exports['howdy-hackminigame']:Begin(2, 3000)

	if success then
		TriggerServerEvent("pl-traffichack:server:changeLights")
	end

	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("pl-traffichack:changeLights")
AddEventHandler("pl-traffichack:changeLights", function()
	for i = 0, 3 do
		SetEntityTrafficlightOverride(object, i)
		Wait(100)
	end

	SetEntityTrafficlightOverride(object, 0)
	Wait(10000) --How long should it be green?
	SetEntityTrafficlightOverride(object, 3)
	object = 0
end)