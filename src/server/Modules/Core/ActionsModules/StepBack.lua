local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local types = require(ReplicatedStorage.Types.Server.Main)
local utils = require(ServerScriptService.Modules.Core.ActionsModules.Utils)

local line: types.Line

function doStepBack(player: types.BathroomPlayer)
    local currentPointIndex = player.Session.CurrentPoint.Value :: number
    local currentPoint = line[currentPointIndex] :: types.LinePoint
	local nextPoint = utils.checkNextPoint(line, currentPointIndex, 1) :: types.LinePoint?
    if utils.movePlayerToPoint(player, currentPoint, nextPoint) then
        player.Session.CurrentPoint.Value = nextPoint.IndexPoint.Value
        nextPoint.OccupiedUser.Value = player
    end
end

function init(line_: types.Line) 
    line = line_
end

return {
    init = init,
    doStepBack = doStepBack,
}