export type PlayerExtraData = {
    Level: IntValue,
    FreeCuts: IntValue,
}

export type PlayerSessionData<T, T2> = {
    Cash: T,
    CurrentMultiplier: T,
    CutPrice: T,
    CurrentPoint: T2,
    BathroomTimer: T2,
}

return true