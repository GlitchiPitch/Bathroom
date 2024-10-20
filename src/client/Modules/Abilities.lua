local ReplicatedStorage = game:GetService("ReplicatedStorage")

local types = require(ReplicatedStorage.Types.Gui.Main)
local abilitiesEvents = require(ReplicatedStorage.EventsList).abilitiesEvents

local abilities: types.Abilities
local abilitiesRemote: RemoteEvent

function onEmergency()
    abilitiesRemote:FireServer(abilitiesEvents.emergency)
end

function onTroll()
    abilitiesRemote:FireServer(abilitiesEvents.troll)
end

function onEveryoneToBathroom()
    abilitiesRemote:FireServer(abilitiesEvents.everyoneToBathroom)
end

function onRunToBathroom()
    abilitiesRemote:FireServer(abilitiesEvents.runToBathroom)
end

function setupButtons()
    abilities.Emergency.Activated:Connect(onEmergency)
    abilities.Troll.Activated:Connect(onTroll)
    abilities.EveryoneToBathroom.Activated:Connect(onEveryoneToBathroom)
    abilities.RunToBathroom.Activated:Connect(onRunToBathroom)
end

function setup() 
    setupButtons()
end

function init(abilities_: types.Abilities, abilitiesRemote_: RemoteEvent)  
    abilitiesRemote = abilitiesRemote_
    abilities = abilities_

    setup()
end

return {
    init = init,
}