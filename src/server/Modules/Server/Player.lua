local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local types = require(ReplicatedStorage.Types.Server.Main)
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