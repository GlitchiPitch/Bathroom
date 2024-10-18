local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local dataStore = DataStoreService:GetDataStore("Bathroom")

local types = require(ReplicatedStorage.Types.Server.Main)

local defaultExtraData = {
    FreeCuts = 3,
    IncomeMultiplier = 1,
    Level = 1,
    PassiveXPIncome = 1,
    UpgradePoints = 1,
}

local defaultSessionData = {
    Cash = 0,
}

function createExtra(playerData)
    local extra = Instance.new("Folder")
    extra.Name = "Extra"
    for key, value in playerData do
        local dataValue = Instance.new("IntValue")
        dataValue.Name = key
        dataValue.Value = value
        dataValue.Parent = extra
    end
    return extra
end

function createSession()
    local session = Instance.new("Folder")
    session.Name = "Session"
    for key, value in defaultSessionData do
        local dataValue = Instance.new("NumberValue")
        dataValue.Name = key
        dataValue.Value = value
        dataValue.Parent = session
    end
    return session
end

function loadData(player: Player) 
    local playerData = dataStore:GetAsync(player.UserId) or defaultExtraData
    local extra = createExtra(playerData)
    local session = createSession()

    extra.Parent = player
    session.Parent = player
end

function saveData(player: types.BathroomPlayer)
    local dataToSave = {}
    local playerData = getPlayerExtraData(player) :: Folder
    if playerData then
        for key, value in playerData:GetChildren() :: {IntValue | NumberValue | StringValue} do
            dataToSave[key] = value.Value
        end
        dataStore:SetAsync(player.UserId, dataToSave)
    else
        warn(`could not be found session data for {player.Name} progress doesn't save`)
    end
end

function getPlayerExtraData(player: types.BathroomPlayer) : Folder
    local extra = player:WaitForChild("Extra") :: Folder
    return extra
end

function getPlayerSessionData(player: types.BathroomPlayer) : Folder
    local session = player:WaitForChild("Session") :: Folder
    return session
end

return {
    loadData = loadData,
    saveData = saveData,
    getPlayerExtraData = getPlayerExtraData,
    getPlayerSessionData = getPlayerSessionData,
}
