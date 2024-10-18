local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local modules = ServerScriptService.Modules
local coreModules = modules.Core
local serverModules = modules.Server

local types = require(ReplicatedStorage.Types.Server.Main)

local lineModule = require(serverModules.Line)

local line: types.Line

function setup()
    lineModule.init(line)
end
function init()
    setup()
end

init()