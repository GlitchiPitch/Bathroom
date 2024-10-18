export type LinePoint = Part & {
    ToilewWaitTimer: IntValue?,
    OccupiedUser: IntValue,
    SurfaceGui: SurfaceGui & {
        Background: ImageLabel,
        Index: ImageLabel,
    }
}

export type Line = Folder & {LinePoint}

return true