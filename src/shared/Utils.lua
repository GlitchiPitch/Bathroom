function formatNumber(num: number)
    if num < 1000 then
        return tostring(num)
    elseif num < 1000000 then
        return string.format("%.1fk", num / 1000)
    else
        return string.format("%.1fm", num / 1000000)
    end
end

function lookAtPart(aPosition: Vector3, bPosition: Vector3) : CFrame
    return CFrame.lookAt(aPosition, bPosition)
end

function extractRotationOnly(aPosition: Vector3, bPosition: Vector3)
    local lookAtCFrame = CFrame.lookAt(aPosition, bPosition)
    local rotationOnlyCFrame = lookAtCFrame - lookAtCFrame.Position

    return rotationOnlyCFrame
end

return {
    formatNumber = formatNumber,
    lookAtPart = lookAtPart,
    extractRotationOnly = extractRotationOnly,
}