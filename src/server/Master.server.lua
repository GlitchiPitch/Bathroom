local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local modules = ServerScriptService.Modules
local coreModules = modules.Core
local serverModules = modules.Server

local types = require(ReplicatedStorage.Types.Server.Main)

local lineModule = require(serverModules.Line)
local playerModule = require(serverModules.Player)
local coreLoop = require(coreModules.Loop)

local cutsModule = require(coreModules.Cuts)

local line: types.Line = workspace.Line

function setupCore()
    cutsModule.init()
end

function setup()
    lineModule.init(line)
    playerModule.init(
        lineModule.getLastFreePoint
    )

    setupCore()
end
function init()
    setup()
    coreLoop.init()
end

init()