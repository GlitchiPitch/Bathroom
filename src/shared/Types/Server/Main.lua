local ReplicatedStorage = game:GetService("ReplicatedStorage")
local dataTypes = require(ReplicatedStorage.Types.Server.Data)

export type LinePoint = Part & {
    OccupiedUser: ObjectValue,
    CutPrice: NumberValue,
    IndexPoint: IntValue,
    SurfaceGui: SurfaceGui & {
        Background: ImageLabel,
        Index: ImageLabel,
    }
}

export type Line = Folder & {LinePoint}

export type ExtraData = Folder & dataTypes.PlayerExtraData<IntValue>
export type SessionData = Folder & dataTypes.PlayerSessionData<NumberValue>

export type BathroomPlayer = Player & {
    Extra: ExtraData,
    Session: SessionData,
}

return true