local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local types = require(ReplicatedStorage.Types.Server.Main)
local actionsUtils = require(ServerScriptService.Modules.Core.ActionsModules.ActionsUtils)

local line: types.Line
local messageRemote: RemoteEvent

function purchaseMessage(player: Player, donatName: string, receipt)
	messageRemote:FireAllClients(
		string.format(
            "[SERVER]: %s bought '%s' for R$%d",
            player.Name,
            donatName,
            receipt.CurrencySpent
        ),
		Color3.fromRGB(84, 213, 55)
	)
end

function cutAction(player: types.BathroomPlayer)
	local currentPointIndex = player.Session.CurrentPoint.Value :: number
	local currentPoint = line[currentPointIndex] :: types.LinePoint
	local nextPoint = actionsUtils.checkNextPoint(line, player, -1) :: types.LinePoint?
	actionsUtils.movePlayerToPoint(line, player, currentPoint, nextPoint)
end

local products = {
	-- @productName "Cut X1"
	[2317679798] = function(player: types.BathroomPlayer, receipt)
		cutAction(player)
		-- purchaseMessage(player, "Cut X1", receipt)
		return true
	end,

	-- @productName "Cut X3"
	[2317694877] = function(player: types.BathroomPlayer, receipt)
		return true
	end,

	-- @productName "Cut X7"
	[2] = function(player: types.BathroomPlayer, receipt)
			return true
		end,

	-- @productName "Cut X12"
	[3] = function(player: types.BathroomPlayer, receipt)
			return true
		end,

	-- @productName "Swap"
	[2319146170] = function(player: types.BathroomPlayer, receipt)
		return true
	end,

	-- @productName "StealCash"
	[2319146247] = function(player: types.BathroomPlayer, receipt)
		return true
	end,

	-- @productName "SendToBack"
	[6] = function(player: types.BathroomPlayer, receipt)
		return true
	end,
}

function processReceipt(receiptInfo)
	local userId = receiptInfo.PlayerId
	local productId = receiptInfo.ProductId
	local player = Players:GetPlayerByUserId(userId)
	if player then
		local handler = products[productId]
		local success, result = pcall(handler, player, receiptInfo)
		if success then
			return Enum.ProductPurchaseDecision.PurchaseGranted
		else
			warn("Failed to process receipt:", receiptInfo, result)
		end
	end
	return Enum.ProductPurchaseDecision.NotProcessedYet
end

function init(line_: types.Line)
	line = line_
	MarketplaceService.ProcessReceipt = processReceipt
end

return {
	init = init,
}
