local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local config = require(ServerScriptService.Config)
local types = require(ReplicatedStorage.Types.Server.Main)

local line: types.Line

function setupLine()
    for i = #line:GetChildren(), 1, -1 do
        local linePoint = line[i] :: types.LinePoint
        linePoint.CutCost.Value = i * config.CUT_COST_MULTIPLIER
        linePoint.SurfaceGui.Enabled = linePoint.OccupiedUser.Value ~= nil
        -- @param value is userId
        linePoint.OccupiedUser.Changed:Connect(function(value: types.BathroomPlayer?)
            linePoint.SurfaceGui.Enabled = value ~= nil
        end)
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

function init(line_: types.Line)
    line = line_

    setup()
end

return {
    init = init,
    getLastFreePoint = getLastFreePoint,
}