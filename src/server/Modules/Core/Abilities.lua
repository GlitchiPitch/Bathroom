local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local types = require(ReplicatedStorage.Types.Server.Main)
local abilitiesEvents = require(ReplicatedStorage.EventsList).abilitiesEvents

local abilitiesRemote: RemoteEvent

function onEmergency(player: types.BathroomPlayer) 

end

function onEveryoneToBathroom(player: types.BathroomPlayer) 

end

function onRunToBathroom(player: types.BathroomPlayer) 

end

function onTrolling(player: types.BathroomPlayer, procudtId: number)
    MarketplaceService:PromptProductPurchase(player, procudtId)
end

local actions = {
    [abilitiesEvents.trolling] = onTrolling,
    [abilitiesEvents.emergency] = onEmergency,
    [abilitiesEvents.everyoneToBathroom] = onEveryoneToBathroom,
    [abilitiesEvents.runToBathroom] = onRunToBathroom,
}

function server(player: Player, action: string, ...: any)
	if actions[action] then
		actions[action](player, ...)
	end
end

function setup()
	abilitiesRemote.OnServerEvent:Connect(server)
end

function init(abilitiesRemote_: RemoteEvent)
	abilitiesRemote = abilitiesRemote_

	setup()
end

return {
	init = init,
}
