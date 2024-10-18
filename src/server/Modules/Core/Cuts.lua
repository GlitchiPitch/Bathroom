local ReplicatedStorage = game:GetService("ReplicatedStorage")

local mainEvents = require(ReplicatedStorage.EventsList).mainEvents
local mainEvent: RemoteEvent

function doCut(player: Player)
    
end

function shove(player: Player)
    
end

function stepBack(player: Player)
    
end

local actions = {
    [mainEvents.doCut] = doCut,
    [mainEvents.shove] = shove,
    [mainEvents.stepBack] = stepBack,
}

function onMainEvent(player: Player, action: string, ...: any)
    if actions[action] then
        actions[action](player, ...)
    else
        warn(`{action} for {script:GetFullName()} is not found`)
    end
end

function setup() 
    mainEvent.OnServerEvent:Connect(onMainEvent)
end

function init()
end

return {
    init = init,
}