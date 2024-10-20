local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local modules = ServerScriptService.Modules
local coreModules = modules.Core
local serverModules = modules.Server

local types = require(ReplicatedStorage.Types.Server.Main)

local lineModule = require(serverModules.Line)
local playerModule = require(serverModules.Player)
local coreLoop = require(coreModules.Loop)
local collisionModule = require(ServerScriptService.Utils.CollisionGroup)

local actionsModule = require(coreModules.Actions)
local products = require(ServerScriptService.Products)

local line: types.Line = workspace.Line
local mainRemote = ReplicatedStorage.Events.MainRemote

function setup()
    products.init(line)
    lineModule.init(
        line,
        mainRemote
    )
    actionsModule.init(
        line,
        mainRemote
    )
    playerModule.init(
        lineModule.getLastFreePoint,
        collisionModule.activateGroupToPlayer,
        mainRemote
    )

end
function init()
    setup()
    coreLoop.init()
end

function init_test()
    local testModules = ServerScriptService.Tests
    local fakePlayers = require(testModules.CreateFakePlayers)
    local dummy = ServerStorage.Rig
    collisionModule.activateGroupToPlayer(dummy)
    fakePlayers.init(line, dummy)
end

init_test()
init()