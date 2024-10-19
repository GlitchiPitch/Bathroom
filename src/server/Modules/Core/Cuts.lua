local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local types = require(ReplicatedStorage.Types.Server.Main)
local mainEvents = require(ReplicatedStorage.EventsList).mainEvents

local mainRemote: RemoteEvent
local line: types.Line

function checkPointIsOccupied(currentPoint: types.LinePoint, nextPoint: types.LinePoint)
    local occupant = nextPoint.OccupiedUser.Value :: types.BathroomPlayer?
    if occupant then
        local humanoid = occupant:FindFirstChildOfClass("Humanoid")
		humanoid:MoveTo(currentPoint.Position)
        occupant.Session.CurrentPoint.Value = currentPoint.IndexPoint.Value
        currentPoint.OccupiedUser.Value = occupant
    end
end

function movePlayerToPoint(player: Player, currentPoint: types.LinePoint, nextPoint: types.LinePoint)
	local character = player.Character
	if character then
        checkPointIsOccupied(currentPoint, nextPoint)
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		humanoid:MoveTo(nextPoint.Position)
		return true
	end
end

function checkNextPoint(currentIndex: number): types.LinePoint
	return line[currentIndex + 1]
end

function cutByCash(player: types.BathroomPlayer, currentPoint: types.LinePoint, nextPoint: types.LinePoint)
	local playerCash = player.Session.Cash.Value :: number
	local cutPrice = currentPoint.CutPrice.Value :: number
	if playerCash >= cutPrice then
		if movePlayerToPoint(player, currentPoint, nextPoint) then
			playerCash.Value -= cutPrice
            player.Session.CurrentPoint.Value = nextPoint.IndexPoint.Value
            nextPoint.OccupiedUser.Value = player
		end
	end
end

function cutByRobux(player: types.BathroomPlayer, currentPoint: types.LinePoint, nextPoint: types.LinePoint)
    movePlayerToPoint(player, currentPoint, nextPoint)
end

function doCut(player: types.BathroomPlayer, productId: number?)
	local currentIndex = player.Session.CurrentIndex.Value :: number
    local currentPoint = line[currentIndex] :: types.LinePoint
	local nextPoint = checkNextPoint(currentIndex) :: types.LinePoint?

	if nextPoint then
		if not productId then
			cutByCash(player, currentPoint, nextPoint)
		else
			print(productId)
            cutByRobux(player, currentPoint, nextPoint)
		end
	end
end

local actions = {
	[mainEvents.doCut] = doCut,
}

function onmainRemote(player: Player, action: string, ...: any)
	if actions[action] then
		actions[action](player, ...)
	else
		warn(`{action} for {script:GetFullName()} is not found`)
	end
end

function setup()
	mainRemote.OnServerEvent:Connect(onmainRemote)
end

function init() end

return {
	init = init,
}
