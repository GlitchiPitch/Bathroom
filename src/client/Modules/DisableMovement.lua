local playerModule: {}

function init(playerModule_)
    playerModule = playerModule_
    local controlModule = playerModule:GetControls()
    controlModule:Disable()
end

return {
    init = init,
}
