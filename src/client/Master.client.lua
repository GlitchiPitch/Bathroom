local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local playerScripts = player.PlayerScripts

local guiTypes = require(ReplicatedStorage.Types.Gui.Main)

local mainGui = playerGui:WaitForChild("Main") :: guiTypes.Main
