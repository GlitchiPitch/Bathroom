local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local modules = StarterPlayer.StarterPlayerScripts.Modules

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local playerScripts = player.PlayerScripts

-- TYPES --
local guiTypes = require(ReplicatedStorage.Types.Gui.Main)

-- MODULES --
local abilities = require(modules.Abilities)
local controlPanel = require(modules.ControlPanel)
local disableMovement = require(modules.DisableMovement)
local progressBar = require(modules.ProgressBar)

local mainGui = playerGui:WaitForChild("Main") :: guiTypes.Main

function setup() end

function init()  
    abilities.init()
    controlPanel.init()
    disableMovement.init()
    progressBar.init()
end

init()