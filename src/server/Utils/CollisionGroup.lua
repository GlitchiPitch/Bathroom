local CollisionGroupService = game:GetService("PhysicsService")
local groupName = "Players"

function activateGroupToPlayer(character: Model)
    
    for i, v in character:GetChildren() do
        if v:IsA("BasePart") or v:IsA("MeshPart") then
            if game.Players:GetPlayerFromCharacter(character) then print(v) end
            v.CollisionGroup = groupName
        end
    end
end

function init()
    CollisionGroupService:RegisterCollisionGroup(groupName)
    CollisionGroupService:CollisionGroupSetCollidable(groupName, groupName, false)
end

init()

return {
    activateGroupToPlayer = activateGroupToPlayer,
}


