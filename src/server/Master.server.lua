local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local modules = ServerScriptService.Modules
local coreModules = modules.Core
local serverModules = modules.Server

local types = require(ReplicatedStorage.Types.Server.Main)

local lineModule = require(serverModules.Line)
local playerModule = require(serverModules.Player)
local coreLoop = require(coreModules.Loop)

local actionsModule = require(coreModules.Actions)

local line: types.Line = workspace.Line
local mainRemote = ReplicatedStorage.Events.MainRemote

function setup()
    lineModule.init(line)
    actionsModule.init(line, mainRemote)
    playerModule.init(
        lineModule.getLastFreePoint,
        mainRemote
    )
end
function init()
    setup()
    coreLoop.init()
end

init()