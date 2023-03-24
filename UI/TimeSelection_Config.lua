Vote = {
    PreVotingTime = 10,
    VotingTime = 30,
    VoteOptions = {
        {
            announceText = "min5",
            btnText = "min5",
            Interval = 300,
        },
        {
            announceText = "min10",
            btnText = "min10",
            Interval = 600,
        },
        {
            announceText = "min15",
            btnText = "min15",
            Interval = 900,
        },
        {
            announceText = "min20",
            btnText = "min20",
            Interval = 1200,
        },
		{
            announceText = "min25",
            btnText = "min25",
            Interval = 1500,
        },
		{
            announceText = "min30",
            btnText = "min30",
            Interval = 1800,
        },
		{
            announceText = "min35",
            btnText = "min35",
            Interval = 2100,
        },
		{
            announceText = "min55",
            btnText = "min55",
            Interval = 3300,
        },
		{
            announceText = "min60",
            btnText = "min60",
            Interval = 3600,
        },
    },
}

Vote2 = {
    PreVotingTime = 10,
    VotingTime = 30,
    VoteOptions2 = {
        {
            announceText = "min5",
            btnText = "min5",
            Interval = 300,
        },
        {
            announceText = "min10",
            btnText = "min10",
            Interval = 600,
        },
        {
            announceText = "min15",
            btnText = "min15",
            Interval = 900,
        },
        {
            announceText = "min20",
            btnText = "min20",
            Interval = 1200,
        },
		{
            announceText = "min25",
            btnText = "min25",
            Interval = 1500,
        },
		{
            announceText = "min30",
            btnText = "min30",
            Interval = 1800,
        },
		{
            announceText = "min35",
            btnText = "min35",
            Interval = 2100,
        },
		{
            announceText = "min55",
            btnText = "min55",
            Interval = 3300,
        },
		{
            announceText = "min60",
            btnText = "min60",
            Interval = 3600,
        },
    },
}

Tech = {
    TechLevels = {
        {
            AlwaysAvailable = true,
            Announce = false,
            AnnounceText = "tech1",
            UnitCategory = "TECH1",
        },
        {
            AlwaysAvailable = false,
            Announce = true,
            AnnounceText = "tech2",
            UnitCategory = "TECH2",
        },
        {
            AlwaysAvailable = false,
            Announce = true,
            AnnounceText = "tech3",
            UnitCategory = "TECH3",
        },
        {
            AlwaysAvailable = false,
            Announce = true,
            AnnounceText = "exptech",
            UnitCategory = "EXPERIMENTAL",
        },
    },
}

Layout = {
    VoteUI = {
        BackgroundTexture = "/mods/Commander Survival Kit/textures/aeon-btn-small-op/medium02_btn_up.dds",
        BackgroundYadj = 0,
        BackgroundHeight = 800,
        BackgroundWidth = 800,
        Button = {
            Xadj = 0,
            Yadj = 0,
			Height = 40,
            Width = 185,
            Texture = "/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon",
            TextSize = 11,
            RollOverSound = "UI_UEF_Rollover",
            OnClickSound = "UI_Menu_MouseDown",
            Spacing = -2,
        },
		Button2 = {
            Xadj = 0,
            Yadj = 0,
			Height = 40,
            Width = 125,
            Texture = "/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon",
            TextSize = 11,
            RollOverSound = "UI_UEF_Rollover",
            OnClickSound = "UI_Menu_MouseDown",
            Spacing = -2,
        },
        CounterSize = 12,
        CounterXadj = 0,
        CounterYadj = 65,
        VoteCounterSize = 12,
        VoteCounterXadj = 175,
        VoteCounterYadj = 65,
        SubtitleSize = 16,
        SubtitleYadj = 2,
        TitleSize = 24,
        TitleYadj = 34,
    },
}

Text = {
    Button2 = {
        submit = "Submit",
    },
    Button = {
        min5 = "5 minutes",
        min10 = "10 minutes",
        min15 = "15 minutes",
        min20 = "20 minutes",
		min25 = "25 minutes",
		min30 = "30 minutes",
		min35 = "35 minutes",
		min40 = "40 minutes",
		min55 = "55 minutes",
		min60 = "60 minutes",
    },
    Announce = {
        tech1 = "Tech 1 is now available!",
        tech2 = "Tech 2 is now available!",
        tech3 = "Tech 3 is now available!",
        exptech = "Experimentals are now available!",
    },
    Vote = {
        Dialog = {
            Title = "Wait Time vote",
            Subtitle = "Point Generation should start in?",
            Counter = "%s seconds remaining",
            VoteCounter = "%s votes in",
        },
        VoteFinished = "Wait Time vote finished",
        VoteResult = {
            min5 = 'New tech available at a 1 minute interval.',
            min10 = 'New tech available at a 10 minute interval.',
            min15 = 'New tech available at a 15 minute interval.',
            min20 = 'New tech available at a 20 minute interval.',
        },
    },
}
