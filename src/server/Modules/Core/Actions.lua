local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local types = require(ReplicatedStorage.Types.Server.Main)
local mainEvents = require(ReplicatedStorage.EventsList).mainEvents

local actionsModules = ServerScriptService.Modules.Core.ActionsModules
local cutsModule = require(actionsModules.Cut)
local stepBackModule = require(actionsModules.StepBack)

local mainRemote: RemoteEvent

local actions = {
	[mainEvents.doCut] = cutsModule.doCut,
	[mainEvents.stepBack] = stepBackModule.doStepBack
}

function onmainRemote(player: Player, action: string, ...: any)
	if actions[action] then
		actions[action](player, ...)
	else
		warn(`{action} for {script:GetFullName()} is not found`)
	end
end

function setup()
	mainRemote.OnServerEvent:Connect(onmainRemote)
end

function init(line: types.Line, mainRemote_: RemoteEvent)
	mainRemote = mainRemote_
	cutsModule.init(line)
	stepBackModule.init(line)
	setup()
end

return {
	init = init,
}
