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
local abilities = require(modules.Abilities)
local controlPanel = require(modules.ControlPanel)
local disableMovement = require(modules.DisableMovement)
local main = require(modules.Main)

local mainGui = playerGui:WaitForChild("Main") :: guiTypes.Main
local playerSessionData = player:WaitForChild("Session") :: types.SessionData
local playerModule = require(playerScripts:WaitForChild("PlayerModule"))

local mainRemote = ReplicatedStorage.Events.MainRemote :: RemoteEvent

function init()
    main.init(
        playerSessionData,
        mainGui.CashAmount,
        mainGui.BathroomTimer,
        mainGui.ProgressBar,
        mainRemote
    )
    abilities.init()
    controlPanel.init(
        mainGui.ControlPanel.Buttons,
        mainRemote
    )
    disableMovement.init(playerModule)
end

init()