local ReplicatedStorage = game:GetService("ReplicatedStorage")

local types = require(ReplicatedStorage.Types.Server.Main)
local abilitiesEvents = require(ReplicatedStorage.EventsList).abilitiesEvents

local abilitiesRemote: RemoteEvent

function onEmergency(player: types.BathroomPlayer) 

end

function onTroll(player: types.BathroomPlayer) 

end

function onEveryoneToBathroom(player: types.BathroomPlayer) 

end

function onRunToBathroom(player: types.BathroomPlayer) 

end

local actions = {
    [abilitiesEvents.emergency] = onEmergency,
    [abilitiesEvents.troll] = onTroll,
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
