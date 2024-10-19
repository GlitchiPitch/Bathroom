export type PlayerExtraData<T> = {
    Level: T,
    FreeCuts: T,
}

export type PlayerSessionData<T> = {
    Cash: T,
    CurrentMultiplier: NumberValue,
    CurrentPoint: IntValue,
    BathroomTimer: IntValue,
}

return true