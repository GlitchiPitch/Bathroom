local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local types = require(ReplicatedStorage.Types.Server.Main)
local dataHandler = require(ServerScriptService.Modules.Server.DataHandler)

local getFreeLastPoint: () -> types.LinePoint


function onCharacterAdded(player: Player, character: Model)
    local freeLinePoint = getFreeLastPoint()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    humanoidRootPart:GetPropertyChangedSignal("CFrame"):Connect(function()
        humanoidRootPart:PivotTo(freeLinePoint.CFrame + Vector3.yAxis * 5)
        freeLinePoint.OccupiedUser.Value = player.UserId
    end)
end

function onPlayerAdded(player: Player)
    dataHandler.loadData(player)
    player.CharacterAdded:Connect(function(character: Model)
        onCharacterAdded(player, character)
    end)
end

function setup() 
    Players.PlayerAdded:Connect(onPlayerAdded)
end

function init(
    getFreeLastPoint_: () -> types.LinePoint
)
    getFreeLastPoint = getFreeLastPoint_
    setup()
end

return {
    init = init,
}