
export type ProgressBar = Frame & {
    Scale: Frame
}

export type ControlPanelRobuxButton = TextButton & {
    Icon: ImageLabel,
    Price: TextLabel,
    CutsValue: TextLabel,
}

export type ControlPanel = Frame & {
    Buttons: Frame & {
        CashButtons: Frame & {
            DoCut: TextButton,
            Shove: TextButton,
            StepBack: TextButton
        },
        RobuxButtons: Frame & {
            X1: ControlPanelRobuxButton,
            X2: ControlPanelRobuxButton,
            X5: ControlPanelRobuxButton,
            X10: ControlPanelRobuxButton,
        }
    },

    FreeCuts: TextButton,
}

export type AbilitiesButton = ImageButton & {AbilityName: TextLabel}

export type Abilities = Frame & {
    Emergency: AbilitiesButton,
    Troll: AbilitiesButton,
    EveryoneToBathroom: AbilitiesButton,
    RunToBathroom: AbilitiesButton,
}

export type Main = ScreenGui & {
    CashAmount: TextLabel,
    ProgressBar: ProgressBar,
    ControlPanel: ControlPanel,
    Abilities: Abilities,
}

return true