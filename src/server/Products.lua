local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local types = require(ReplicatedStorage.Types.Server.Main)
local actionUtils = require(ServerScriptService.Modules.Core.ActionsModules.Utils)

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

function cutAction(player)
	local currentPointIndex = player.Session.CurrentPoint.Value :: number
	local currentPoint = line[currentPointIndex] :: types.LinePoint
	local nextPoint = actionUtils.checkNextPoint(line, player, -1) :: types.LinePoint?
	actionUtils.movePlayerToPoint(player, currentPoint, nextPoint)
	player.Session.CurrentPoint.Value = nextPoint.IndexPoint.Value
	nextPoint.OccupiedUser.Value = player
end

local products = {
	-- @productName "Cut X1"
	[2317679798] = function(player: types.BathroomPlayer, receipt)
		cutAction(player)
		purchaseMessage(player, "Cut X1", receipt)
		return true
	end,

	-- @productName "Cut X3"
	[2317694877] = function(player: types.BathroomPlayer)
		return true
	end,

	[2] = {
		Name = "Cut X7",
		Function = function(Player, Receipt)
			print(Player, Receipt)
			return true
		end,
	},

	[3] = {
		Name = "Cut X12",
		Function = function(Player, Receipt)
			print(Player, Receipt)
			return true
		end,
	},

	[4] = {
		Name = "Swap",
		Function = function(Player, Receipt)
			print(Player, Receipt)
			return true
		end,
	},
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
