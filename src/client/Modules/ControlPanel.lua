local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local guiTypes = require(ReplicatedStorage.Types.Gui.Main)
local config = require(StarterPlayer.StarterPlayerScripts.Config)
-- local freeCuts: IntValue

local buttons: guiTypes.ControlPanelButtons
local mainRemote: RemoteEvent
local playerCash: NumberValue
local currentCutPrice: NumberValue

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
    playerCash.Changed:Connect(function(value: number)
        buttons.CashButtons.DoCut.BackgroundColor3 = value < currentCutPrice.Value and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
    end)
end

function setupRobuxButtons()
    setupButtons(buttons.RobuxButtons)
end

function updateCutPrice()
    buttons.CashButtons.DoCut.Text = "$" .. " " .. currentCutPrice.Value
    currentCutPrice.Changed:Connect(function(value: number)
        buttons.CashButtons.DoCut.Text = "$" .. " " .. value    
    end)
end

function setup() 
    setupCashButtons()
    setupRobuxButtons()
    updateCutPrice()
end

function init(
    controlPanelButtons_: guiTypes.ControlPanelButtons,
    currentCutPrice_: NumberValue,
    mainRemote_: RemoteEvent,
    playerCash_: NumberValue
) 
    currentCutPrice = currentCutPrice_
    buttons = controlPanelButtons_
    mainRemote = mainRemote_
    playerCash = playerCash_
    setup()
end

return {
    init = init,
    updateCutCost = updateCutPrice,
}