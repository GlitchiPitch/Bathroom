local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local guiTypes = require(ReplicatedStorage.Types.Gui.Main)
local types = require(ReplicatedStorage.Types.Server.Main)
local config = require(StarterPlayer.StarterPlayerScripts.Config)
local abilitiesEvents = require(ReplicatedStorage.EventsList).abilitiesEvents

local abilities: guiTypes.Abilities
local trolling: guiTypes.Trolling
local controlPanel: guiTypes.ControlPanel
local abilitiesRemote: RemoteEvent
local setupCamera: config.SetupCameraParams

function setupTrolling()
    for _, v in trolling.Buttons:GetChildren() do
        if v:IsA("GuiButton") then
            local button = v :: ImageButton
            local productId = button:GetAttribute(config.controlPanelButtonAttributes.productId) :: number?
            button.Activated:Connect(function()
                abilitiesRemote:FireServer(abilitiesEvents.trolling, productId)
            end)
        end
    end

end

function onEmergency()
    abilitiesRemote:FireServer(abilitiesEvents.emergency)
end

function onTroll()
    trolling.Visible = not trolling.Visible
    controlPanel.Visible = not trolling.Visible
    local humanoid: Humanoid
    
    if trolling.Visible then
        -- local players = Players:GetPlayers() :: {types.BathroomPlayer}
        -- local randomPlayer = players[#players] :: types.BathroomPlayer
        -- local humanoid = randomPlayer.Character:FindFirstChildOfClass("Humanoid")

        local players = workspace:FindFirstChild("FakePlayersfolder"):GetChildren() :: {types.BathroomPlayer}
        local randomPlayer = players[#players] :: types.BathroomPlayer
        humanoid = randomPlayer:FindFirstChildOfClass("Humanoid")
    else
        local player = Players.LocalPlayer
        humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    end

    setupCamera(humanoid)
end

function onEveryoneToBathroom()
    abilitiesRemote:FireServer(abilitiesEvents.everyoneToBathroom)
end

function onRunToBathroom()
    abilitiesRemote:FireServer(abilitiesEvents.runToBathroom)
end

function setupButtons()
    abilities.Emergency.Activated:Connect(onEmergency)
    abilities.Troll.Activated:Connect(onTroll)
    abilities.EveryoneToBathroom.Activated:Connect(onEveryoneToBathroom)
    abilities.RunToBathroom.Activated:Connect(onRunToBathroom)
end

function setup() 
    setupButtons()
    setupTrolling()
end

function init(
    abilities_: guiTypes.Abilities, 
    trolling_: guiTypes.Trolling,
    controlPanel_: guiTypes.ControlPanel,
    abilitiesRemote_: RemoteEvent, 
    setupCamera_: config.SetupCameraParams
)
    abilitiesRemote = abilitiesRemote_
    controlPanel = controlPanel_
    abilities = abilities_
    setupCamera = setupCamera_
    trolling = trolling_

    setup()
end

return {
    init = init,
}