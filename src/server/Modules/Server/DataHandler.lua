-- local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local dataStore = DataStoreService:GetDataStore("Bathroom")

local types = require(ReplicatedStorage.Types.Server.Main)
local dataTypes = require(ReplicatedStorage.Types.Server.Data)

local defaultExtraData = {
    FreeCuts = 3,
    IncomeMultiplier = 1,
    Level = 1,
    PassiveXPIncome = 1,
    UpgradePoints = 1,
}

local defaultSessionData: dataTypes.PlayerSessionData<number, number> = {
    Cash = 0,
    BathroomTimer = 50,
    CurrentPoint = 0,
    CutPrice = 0
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

-- #### @action add into player Extra & Session data folders
function loadData(player: Player) 
    local playerData = defaultExtraData
    -- local playerData = dataStore:GetAsync(player.UserId) or defaultExtraData
    local extra = createExtra(playerData)
    local session = createSession()

    extra.Parent = player
    session.Parent = player
end

function saveData(player: types.BathroomPlayer)
    local dataToSave = {}
    local playerData = player.Extra :: Folder
    if playerData then
        for key, value in playerData:GetChildren() :: {IntValue | NumberValue | StringValue} do
            dataToSave[key] = value.Value
        end
        -- dataStore:SetAsync(player.UserId, dataToSave)
    else
        warn(`could not be found session data for {player.Name} progress doesn't save`)
    end
end

return {
    loadData = loadData,
    saveData = saveData,
}
