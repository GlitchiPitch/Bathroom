local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.Types.Server.Main)

local FAKE_PLAYERS_AMOUNT = 3

local fakePlayersfolder = Instance.new("Folder")

local line: types.Line
local dummy: Model

function create()
    for i = 1, FAKE_PLAYERS_AMOUNT do
        local point = line[i] :: types.LinePoint
        local fakePlayer = dummy:Clone()
        fakePlayer.Parent = fakePlayersfolder
        fakePlayer:PivotTo(point.CFrame + Vector3.yAxis * 5)
        point.OccupiedUser.Value = fakePlayer
        fakePlayer.Session.CurrentPoint.Value = point.IndexPoint.Value
    end
end

function init(line_: types.Line, dummy_: Model) 
    line = line_
    dummy = dummy_

    fakePlayersfolder.Parent = workspace
    create()
end

return {
    init = init,
}
