local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local guiTypes = require(ReplicatedStorage.Types.Gui.Main)
local config = require(StarterPlayer.StarterPlayerScripts.Config)
local mainEvents = require(ReplicatedStorage.EventsList).mainEvents
-- local freeCuts: IntValue

local buttons: guiTypes.ControlPanelButtons
local mainRemote: RemoteEvent

function setupButtons(panelButtons: guiTypes.CashButtons | guiTypes.RobuxButtons)
    for _, v in panelButtons:GetDescendants() do
        if v:IsA("GuiButton") then
            local button = v :: guiTypes.ControlPanelCashButton | guiTypes.ControlPanelRobuxButton
            local eventName = button:GetAttribute(config.controlPanelButtonAttributes.event) :: string
            local productId = button:GetAttribute(config.controlPanelButtonAttributes.productId) :: number?
            button.Activated:Connect(function()
                mainRemote:FireServer(eventName, productId)
            end)
        end
    end
end

function setupCashButtons()
    setupButtons(buttons.CashButtons)
end

function setupRobuxButtons()
    setupButtons(buttons.RobuxButtons)
end

function updateCutPrice(newValue: number)
    print(newValue)
    buttons.CashButtons.DoCut.Text = "$" .. " " .. newValue
end

local actions = {
    [mainEvents.updateCutPrice] =  updateCutPrice,
}

function onMainRemote(action: string, ...: any)
    if actions[action] then
        actions[action](...)
    end
end

function setup() 
    setupCashButtons()
    setupRobuxButtons()
    mainRemote.OnClientEvent:Connect(onMainRemote)
end

function init(
    controlPanelButtons_: guiTypes.ControlPanelButtons,
    mainRemote_: RemoteEvent
) 
    buttons = controlPanelButtons_
    mainRemote = mainRemote_

    setup()
end

return {
    init = init,
    updateCutCost = updateCutPrice,
}