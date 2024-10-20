local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local types = require(ReplicatedStorage.Types.Server.Main)
local dataHandler = require(ServerScriptService.Modules.Server.DataHandler)
local mainEvents = require(ReplicatedStorage.EventsList).mainEvents

local getFreeLastPoint: () -> types.LinePoint
local activateCollisionGroupToPlayer: (character: Model) -> nil
local mainRemote: RemoteEvent

function onCharacterAdded(player: types.BathroomPlayer, character: Model)
    local freeLinePoint = getFreeLastPoint()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    humanoidRootPart:GetPropertyChangedSignal("CFrame"):Connect(function()
        humanoidRootPart:PivotTo(freeLinePoint.CFrame + Vector3.yAxis * 5)
        freeLinePoint.OccupiedUser.Value = player
        player.Session.CurrentPoint.Value = freeLinePoint.IndexPoint.Value
    end)
    -- @warn for test this function must be called another
    activateCollisionGroupToPlayer(character)
end

-- connect to changes of values
function setupPlayer(player: types.BathroomPlayer)
    local pointIndex = player.Session.CurrentPoint :: IntValue
    local timerTask: thread
    pointIndex.Changed:Connect(function(value: number)
        print(value)
        if value == 1 then
            mainRemote:FireClient(player, mainEvents.bathroomTimer, true)
            timerTask = task.defer(function()
                local bathroomTimer = player.Session.BathroomTimer :: IntValue
                local bathroomTimerValue = bathroomTimer.Value :: number
                for _ = bathroomTimerValue, 0, -1 do
                    task.wait(1)
                    bathroomTimer.Value -= 1
                end
            end)
        else
            if timerTask then
                print("task.cancel(timerTask)")
                mainRemote:FireClient(player, mainEvents.bathroomTimer, false)
                task.cancel(timerTask)
                timerTask = nil
            end
        end
    end)
end

function onPlayerAdded(player: Player)
    dataHandler.loadData(player)
    setupPlayer(player)
    player.CharacterAdded:Connect(function(character: Model)
        onCharacterAdded(player, character)
    end)
end

function setup() 
    Players.PlayerAdded:Connect(onPlayerAdded)
end

function init(
    getFreeLastPoint_: () -> types.LinePoint,
    activateCollisionGroupToPlayer_: (character: Model) -> nil,
    mainRemote_: RemoteEvent
)
    getFreeLastPoint = getFreeLastPoint_
    activateCollisionGroupToPlayer = activateCollisionGroupToPlayer_
    mainRemote = mainRemote_

    setup()
end

return {
    init = init,
}