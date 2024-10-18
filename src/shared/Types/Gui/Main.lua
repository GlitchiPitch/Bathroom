
export type ProgressBar = Frame & {
    Scale: Frame
}

export type ControlPanelRobuxButton = TextButton & {
    Icon: ImageLabel,
    Price: TextLabel,
    CutsValue: TextLabel,
}

export type ControlPanelCashButton = TextButton

export type CashButtons = Frame & {
    DoCut: ControlPanelCashButton,
    Shove: ControlPanelCashButton,
    StepBack: ControlPanelCashButton,
}

export type RobuxButtons = Frame & {
    X1: ControlPanelRobuxButton,
    X3: ControlPanelRobuxButton,
    X7: ControlPanelRobuxButton,
    X12: ControlPanelRobuxButton,
}

export type ControlPanelButtons = Frame & {
    CashButtons: CashButtons,
    RobuxButtons: RobuxButtons,
}

export type ControlPanel = Frame & {
    Buttons: ControlPanelButtons,
    FreeCuts: TextButton,
}

export type AbilitiesButton = ImageButton & {AbilityName: TextLabel}

export type Abilities = Frame & {
    Emergency: AbilitiesButton,
    Troll: AbilitiesButton,
    EveryoneToBathroom: AbilitiesButton,
    RunToBathroom: AbilitiesButton,
}

export type ToiletTimer = TextLabel

export type Main = ScreenGui & {
    CashAmount: TextLabel,
    ProgressBar: ProgressBar,
    ControlPanel: ControlPanel,
    Abilities: Abilities,
    ToiletTimer: ToiletTimer,
}

return true