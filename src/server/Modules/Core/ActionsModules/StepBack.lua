local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local types = require(ReplicatedStorage.Types.Server.Main)
local actionsUtils = require(ServerScriptService.Modules.Core.ActionsModules.ActionsUtils)

local line: types.Line

function doStepBack(player: types.BathroomPlayer)
    local currentPointIndex = player.Session.CurrentPoint.Value :: number
    local currentPoint = line[currentPointIndex] :: types.LinePoint
	local nextPoint = actionsUtils.checkNextPoint(line, player, 1) :: types.LinePoint?
    if nextPoint.OccupiedUser.Value ~= nil then
        actionsUtils.movePlayerToPoint(line, player, currentPoint, nextPoint)
    end
end

function init(line_: types.Line) 
    line = line_
end

return {
    init = init,
    doStepBack = doStepBack,
}