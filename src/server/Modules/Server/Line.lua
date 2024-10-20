local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local config = require(ServerScriptService.Config)
local types = require(ReplicatedStorage.Types.Server.Main)
local mainEvents = require(ReplicatedStorage.EventsList).mainEvents

local line: types.Line
local mainRemote: RemoteEvent


function setupLine()
    for i = #line:GetChildren(), 1, -1 do
        local linePoint = line[i] :: types.LinePoint
        if i ~= 1 then
            linePoint.CutPrice.Value = ((#line:GetChildren() - i) * config.CUT_COST_MULTIPLIER) + config.CUT_COST_MULTIPLIER
            linePoint.SurfaceGui.Enabled = linePoint.OccupiedUser.Value ~= nil
            linePoint.OccupiedUser.Changed:Connect(function(occupant: types.BathroomPlayer?)
                linePoint.SurfaceGui.Enabled = occupant ~= nil
                if occupant ~= nil then
                    -- @warn TEST
                    if not occupant:IsA("Player") then return end
                    mainRemote:FireClient(occupant, mainEvents.updateCutPrice, linePoint.CutPrice.Value)
                end
            end)
        else
            linePoint.SurfaceGui.Enabled = true
        end
        linePoint.SurfaceGui.Index.Text = i
        linePoint.IndexPoint.Value = i
        -- linePoint.OccupiedUser.Value = 0
    end
end

function getLastFreePoint() : types.LinePoint
    for i = 1, #line:GetChildren() do
        local linePoint = line[i] :: types.LinePoint
        if linePoint.OccupiedUser.Value ~= nil then continue end
        return linePoint
    end
end

function setup() 
   setupLine() 
end

function init(line_: types.Line, mainRemote_: RemoteEvent)
    line = line_
    mainRemote = mainRemote_

    setup()
end

return {
    init = init,
    getLastFreePoint = getLastFreePoint,
}