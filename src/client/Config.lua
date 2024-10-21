local controlPanelButtonAttributes = {
    event = "Event",
    productId = "ProductId",
}

export type SetupCameraParams = (
    camerasubject: Humanoid, 
    targetCFrame: CFrame, 
    tweenInfo: {duration: number, isWaiting: boolean?}?
) -> ()

return {
    controlPanelButtonAttributes = controlPanelButtonAttributes,
}