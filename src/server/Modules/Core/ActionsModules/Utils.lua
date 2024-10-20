local ReplicatedStorage = game:GetService("ReplicatedStorage")

local types = require(ReplicatedStorage.Types.Server.Main)

-- @param direction 1 or -1
function checkNextPoint(line: types.Line, player: types.BathroomPlayer, direction: number) : types.LinePoint?
    local currentPointIndex = player.Session.CurrentPoint.Value :: number
    local nextIndex = currentPointIndex + (1 * direction)
    if line:FindFirstChild(tostring(nextIndex)) then
        return line[nextIndex]
    else
        warn(`{nextIndex} is not member of line`)
    end
end

function getPointsAroundPlayer(line: types.Line, player: types.BathroomPlayer) : {currentPoint: types.LinePoint?, nextPoint: types.LinePoint?}
    local currentPointIndex = player.Session.CurrentPoint.Value :: number
    local currentPoint = line[currentPointIndex] :: types.LinePoint
	local nextPoint = checkNextPoint(line, currentPointIndex, -1) :: types.LinePoint?
    return {
        currentPoint = currentPoint,
        nextPoint = nextPoint,
    }

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
        currentPoint.OccupiedUser.Value = nil
        checkPointIsOccupied(currentPoint, nextPoint)

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		humanoid:MoveTo(nextPoint.Position)

        player.Session.CurrentPoint.Value = nextPoint.IndexPoint.Value
        nextPoint.OccupiedUser.Value = player
		return true
	end
end

return {
    checkNextPoint = checkNextPoint,
    movePlayerToPoint = movePlayerToPoint,
    getPointsAroundPlayer = getPointsAroundPlayer,
}