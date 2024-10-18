local ReplicatedStorage = game:GetService("ReplicatedStorage")
local dataTypes = require(ReplicatedStorage.Types.Server.Data)

export type LinePoint = Part & {
    ToilewWaitTimer: IntValue?,
    OccupiedUser: IntValue,
    SurfaceGui: SurfaceGui & {
        Background: ImageLabel,
        Index: ImageLabel,
    }
}

export type Line = Folder & {LinePoint}

export type BathroomPlayer = Player & {
    Extra: Folder & dataTypes.PlayerExtraData<IntValue>,
    Session: Folder & dataTypes.PlayerSessionData<IntValue>,
}

return true