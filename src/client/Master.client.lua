local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local modules = StarterPlayer.StarterPlayerScripts.Modules

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local playerScripts = player.PlayerScripts

-- TYPES --
local guiTypes = require(ReplicatedStorage.Types.Gui.Main)
local types = require(ReplicatedStorage.Types.Server.Main)

-- MODULES --
local abilitiesModule = require(modules.Abilities)
local controlPanelModule = require(modules.ControlPanel)
local disableMovementModule = require(modules.DisableMovement)
local mainModule = require(modules.Main)
local cameraModule = require(modules.Camera)

local camera = workspace.CurrentCamera
local mainGui = playerGui:WaitForChild("Main") :: guiTypes.Main
local playerSessionData = player:WaitForChild("Session") :: types.SessionData
local playerModule = require(playerScripts:WaitForChild("PlayerModule"))

local mainRemote = ReplicatedStorage.Events.MainRemote :: RemoteEvent
local abilitiesRemote = ReplicatedStorage.Events.AbilitiesRemote :: RemoteEvent

function init()
    cameraModule.init(camera)
    mainModule.init(
        playerSessionData,
        mainGui.CashAmount,
        mainGui.BathroomTimer,
        mainGui.ProgressBar,
        mainRemote
    )
    abilitiesModule.init(
        mainGui.Abilities,
        mainGui.Trolling,
        mainGui.ControlPanel,
        abilitiesRemote,
        cameraModule.setupCamera
    )
    controlPanelModule.init(
        mainGui.ControlPanel.Buttons,
        playerSessionData.CutPrice,
        mainRemote,
        playerSessionData.Cash
    )
    disableMovementModule.init(playerModule)
end

init()