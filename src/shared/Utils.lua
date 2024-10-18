function formatNumber(num: number)
    if num < 1000 then
        return tostring(num)
    elseif num < 1000000 then
        return string.format("%.1fk", num / 1000)
    else
        return string.format("%.1fm", num / 1000000)
    end
end

return {
    formatNumber = formatNumber,
}