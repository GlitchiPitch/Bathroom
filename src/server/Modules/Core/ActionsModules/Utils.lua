local ReplicatedStorage = game:GetService("ReplicatedStorage")

local types = require(ReplicatedStorage.Types.Server.Main)

-- @param direction 1 or -1
function checkNextPoint(line: types.Line, currentIndex: number, direction: number) : types.LinePoint?
    if line:FindFirstChild(tostring(currentIndex + (1 * direction))) then
        return line[currentIndex + (1 * direction)]
    else
        warn(`{currentIndex + (1 * direction)} is not member of line`)
    end
end

-- #### @action step back for player which occupied next line point
function checkPointIsOccupied(currentPoint: types.LinePoint, nextPoint: types.LinePoint)
    local occupant = nextPoint.OccupiedUser.Value :: types.BathroomPlayer?
    if occupant then
        local humanoid = occupant:FindFirstChildOfClass("Humanoid")
		humanoid:MoveTo(currentPoint.Position)
        occupant.Session.CurrentPoint.Value = currentPoint.IndexPoint.Value
        currentPoint.OccupiedUser.Value = occupant
        nextPoint.OccupiedUser.Value = nil
    end
end

function movePlayerToPoint(player: Player, currentPoint: types.LinePoint, nextPoint: types.LinePoint)
	local character = player.Character
	if character then
        checkPointIsOccupied(currentPoint, nextPoint)
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		humanoid:MoveTo(nextPoint.Position)
        currentPoint.OccupiedUser.Value = nil
		return true
	end
end

return {
    checkNextPoint = checkNextPoint,
    movePlayerToPoint = movePlayerToPoint,
}