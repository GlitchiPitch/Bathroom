local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local config = require(ServerScriptService.Config)
local mainTypes = require(ReplicatedStorage.Types.Server.Main)

function giveCashToPlayers()
	coroutine.wrap(function()
		while task.wait(config.GIVE_CASH_TIMER) do
			if #Players:GetPlayers() > 0 then
				for _, player in Players:GetPlayers() :: { mainTypes.BathroomPlayer } do
					local playerCash = player.Session.Cash :: NumberValue
					-- local currentMultiplier = player.Session.CurrentMultiplier :: NumberValue
					local income = config.BASIC_CASH_INCOME -- * (currentMultiplier.Value or 1)
					playerCash.Value += income
				end
            else
                break
			end
		end
	end)()
end

function init()
	giveCashToPlayers()
end

return {
	init = init,
}
