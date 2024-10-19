local ReplicatedStorage = game:GetService("ReplicatedStorage")

local types = require(ReplicatedStorage.Types.Server.Main)
local mainEvents = require(ReplicatedStorage.EventsList).mainEvents
-- local reConfig = require(ReplicatedStorage.Config)

local cashLabel: TextLabel
local bathroomTimer: TextLabel
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
    mainRemote.OnClientEvent:Connect(onMainRemote)
end
function init(
    playerSessionData_: types.SessionData, 
    cashLabel_: TextLabel, 
    bathroomTimer_: TextLabel,
    mainRemote_: RemoteEvent
) 
    playerSessionData = playerSessionData_
    cashLabel = cashLabel_
    bathroomTimer = bathroomTimer_
    mainRemote = mainRemote_
    setup()
end

return {
    init = init,
}