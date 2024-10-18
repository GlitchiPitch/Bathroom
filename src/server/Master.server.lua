local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local modules = ServerScriptService.Modules
local coreModules = modules.Core
local serverModules = modules.Server

local types = require(ReplicatedStorage.Types.Server.Main)

local lineModule = require(serverModules.Line)
local playerModule = require(serverModules.Player)

local line: types.Line

function setup()
    lineModule.init(line)
    playerModule.init(
        lineModule.getLastFreePoint
    )
end
function init()
    setup()
end

init()