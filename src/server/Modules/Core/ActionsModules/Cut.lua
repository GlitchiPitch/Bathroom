local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local types = require(ReplicatedStorage.Types.Server.Main)
local actionsUtils = require(ServerScriptService.Modules.Core.ActionsModules.ActionsUtils)

local line: types.Line

function cutByCash(player: types.BathroomPlayer, currentPoint: types.LinePoint, nextPoint: types.LinePoint)
	local playerCash = player.Session.Cash :: NumberValue
	local cutPrice = currentPoint.CutPrice.Value :: number
	if playerCash.Value >= cutPrice then
		if actionsUtils.movePlayerToPoint(line, player, currentPoint, nextPoint) then
			playerCash.Value -= cutPrice
		end
	end
end

function cutByRobux(player: types.BathroomPlayer, productId: number)
    MarketplaceService:PromptProductPurchase(player, productId)
end

function doCut(player: types.BathroomPlayer, productId: number?)
	local currentPointIndex = player.Session.CurrentPoint.Value :: number
    local currentPoint = line[currentPointIndex] :: types.LinePoint
	local nextPoint = actionsUtils.checkNextPoint(line, player, -1) :: types.LinePoint?

	if nextPoint then
		if not productId then
			cutByCash(player, currentPoint, nextPoint)
		else
            cutByRobux(player, productId)
		end
	end
end

function init(line_: types.Line)
    line = line_
end

return {
    init = init,
    doCut = doCut,
}