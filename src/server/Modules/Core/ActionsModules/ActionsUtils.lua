local ReplicatedStorage = game:GetService("ReplicatedStorage")

local types = require(ReplicatedStorage.Types.Server.Main)
local commonUtils = require(ReplicatedStorage.Utils)

-- @param direction 1 or -1
function checkNextPoint(line: types.Line, player: types.BathroomPlayer, direction: number): types.LinePoint?
	local currentPointIndex = player.Session.CurrentPoint.Value :: number
	local nextIndex = currentPointIndex + (1 * direction)
	if line:FindFirstChild(tostring(nextIndex)) then
		return line[nextIndex]
	else
		warn(`{nextIndex} is not member of line`)
	end
end


function move(line: types.Line, player: types.BathroomPlayer, currentPoint: types.LinePoint, nextPoint: types.LinePoint)
    local humanoid
    local humanoidRootPart
    if player:IsA("Player") then
        humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    else
        humanoid = player:FindFirstChildOfClass("Humanoid")
        humanoidRootPart = player:FindFirstChild("HumanoidRootPart")
    end

    if humanoid.MoveDirection ~= Vector3.zero then
        humanoid:MoveTo(nextPoint.Position)
    else
        humanoid:MoveTo(nextPoint.Position)
        coroutine.wrap(function()
            repeat task.wait(.5) until humanoid.MoveDirection == Vector3.zero
            -- local forwardPoint = line[player.Session.CurrentPoint.Value + 1] :: types.LinePoint
            -- if player:IsA("Player") then
            --     local lookAt = commonUtils.extractRotationOnly(player.Character:GetPivot().Position, forwardPoint.Position)
            --     player.Character:PivotTo(lookAt)
            -- else
            --     local lookAt = commonUtils.lookAtPart(player:GetPivot().Position, forwardPoint.Position)
            --     player:PivotTo(lookAt)
            -- end
        end)()
    end

end

-- #### @action step back for player which occupied next line point
function checkPointIsOccupied(line: types.Line, currentPoint: types.LinePoint, nextPoint: types.LinePoint)
	local occupant = nextPoint.OccupiedUser.Value :: types.BathroomPlayer?
	if occupant then
        move(line, occupant, nextPoint, currentPoint)

		occupant.Session.CurrentPoint.Value = currentPoint.IndexPoint.Value
		currentPoint.OccupiedUser.Value = occupant
		nextPoint.OccupiedUser.Value = nil
	end
end

function movePlayerToPoint(line: types.Line, player: Player, currentPoint: types.LinePoint, nextPoint: types.LinePoint)
	local character = player.Character
	if character then
		currentPoint.OccupiedUser.Value = nil
		checkPointIsOccupied(line, currentPoint, nextPoint)
        move(line, player, currentPoint, nextPoint)
		player.Session.CurrentPoint.Value = nextPoint.IndexPoint.Value
		nextPoint.OccupiedUser.Value = player
		return true
	end
end

return {
	checkNextPoint = checkNextPoint,
	movePlayerToPoint = movePlayerToPoint,
}
