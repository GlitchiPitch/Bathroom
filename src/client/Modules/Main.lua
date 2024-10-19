local ReplicatedStorage = game:GetService("ReplicatedStorage")

local types = require(ReplicatedStorage.Types.Server.Main)
local guiTypes = require(ReplicatedStorage.Types.Gui.Main)
local mainEvents = require(ReplicatedStorage.EventsList).mainEvents
local config = require(ReplicatedStorage.Config)

local cashLabel: TextLabel
local bathroomTimer: TextLabel
local progressBar: guiTypes.ProgressBar
local controlPanel: guiTypes.ControlPanel
local playerSessionData: types.SessionData

local mainRemote: RemoteEvent

function onCashChanged(cashAmount: number)
    cashLabel.Text = cashAmount
end

function onBathroomTimerChanged(currentTime: number)
    bathroomTimer.Text = currentTime
end

function activateBathroomTimer()
    bathroomTimer.Visible = not bathroomTimer.Visible
    controlPanel.Visible = not controlPanel.Visible
end

function onCurrentPointChanged(currentPoint: number)
    local fillPercentage = math.clamp(currentPoint / config.POINTS_AMOUNT, 0, 1)
    progressBar.Scale.Size = UDim2.fromScale(fillPercentage, 1)
end

local actions = {
    [mainEvents.bathroomTimer] = activateBathroomTimer,
}

function onMainRemote(action: string, ...: any)
    if actions[action] then
        actions[action](...)
    end
end

function setup()
    playerSessionData.Cash.Changed:Connect(onCashChanged)
    playerSessionData.BathroomTimer.Changed:Connect(onBathroomTimerChanged)
    playerSessionData.CurrentPoint.Changed:Connect(onCurrentPointChanged)
    mainRemote.OnClientEvent:Connect(onMainRemote)
end
function init(
    playerSessionData_: types.SessionData,
    controlPanel_: guiTypes.ControlPanel,
    cashLabel_: TextLabel, 
    bathroomTimer_: TextLabel,
    progressBar_: guiTypes.ProgressBar,
    mainRemote_: RemoteEvent
) 
    playerSessionData = playerSessionData_
    controlPanel = controlPanel_
    cashLabel = cashLabel_
    bathroomTimer = bathroomTimer_
    progressBar = progressBar_
    mainRemote = mainRemote_
    setup()
end

return {
    init = init,
}