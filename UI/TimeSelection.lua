do

local TTT_Path = import('/lua/game.lua').TTT_ModPath
local Config = import(TTT_Path..'/TimeSelection_Config.lua')
local Movie = import('/lua/maui/movie.lua').Movie
local GameMain = import('/lua/ui/game/gamemain.lua')
local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Group = import('/lua/maui/group.lua').Group
local Text = import('/lua/maui/text.lua').Text
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local Tooltip = import('/lua/ui/game/tooltip.lua')
local CreateAnnouncement = import('/lua/ui/game/announcement.lua').CreateAnnouncement
local CreateText = import('/lua/maui/text.lua').Text 
local CreateWindow = import('/lua/maui/window.lua').Window
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local factions = import('/lua/factions.lua').Factions

----parameters----
local Border = {
        tl = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_ul.dds'),
        tr = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_ur.dds'),
        tm = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_horz_um.dds'),
        ml = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_vert_l.dds'),
        m = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_m.dds'),
        mr = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_vert_r.dds'),
        bl = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_ll.dds'),
        bm = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_lm.dds'),
        br = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_lr.dds'),
        borderColor = 'ff415055',
}
	
local Position = {
	Left = 330, 
	Top = 220, 
	Bottom = 320, 
	Right = 660
}

local TextPosition = {
	Left = 350, 
	Top = 250, 
	Bottom = 260, 
	Right = 550
}

local TextPosition2 = {
	Left = 350, 
	Top = 270, 
	Bottom = 280, 
	Right = 550
}

local TextPosition3 = {
	Left = 350, 
	Top = 290, 
	Bottom = 300, 
	Right = 550
}
   
----actions----
 

local VoteOptions = {}
local VoteOptions2 = {}
local Votes = {}
local Votes2 = {}
local WinningVote = 0
local WinningVote2 = 0
local UI = false
local VoteTime = 120
local NumVotesIn = 0
local NumVotesIn2 = 0

-- #### SIM TO UI STUFF ####

function SetVoteOptions( voteOptions)
    VoteOptions = voteOptions
    CreateRefUIButtons()
end

function SetVoteOptions2( voteOptions2)
    VoteOptions2 = voteOptions2
	CreateFSUIButtons()
end

function SetVotes( votes)
    Votes = votes
end

function SetVoteTime( voteTime)
    VoteTime = voteTime
end

function SetNumVotesIn( numVotes)
    NumVotesIn = numVotes
    if UI then
        UI.voteCount.Update()
    end
end

function SetNumVotesIn2( numVotes2)
    NumVotesIn2 = numVotes2
    if UI then
        UI.voteCount.Update()
    end
end

function SetWinningVote( winningVote)
    WinningVote = winningVote
end

function SetWinningVote2( winningVote2)
    WinningVote2 = winningVote2
end

function ShowVoteUI()
    if UI then
        --UI:Show()
		CreateOkayButton()
        UI.voteTimeLeft.counterEndSec = GetGameTimeSeconds() + VoteTime
        GameMain.AddBeatFunction(UI.voteTimeLeft.UpdateFunc)  -- enable the counter
    end
end

function HideVoteUI()
    if UI then
        UI:Hide()
        GameMain.RemoveBeatFunction(UI.voteTimeLeft.UpdateFunc)  -- disable the counter
    end
end

function AnnounceVoteOver()
    -- create a 2 line announcement (like the one that says "no rush time over") and make it destroy the UI after
    -- it's done cause after this we don't need the UI anymore.
    local text1 = Config.Text.Vote.VoteFinished
    local text2 = Config.Text.Vote.VoteResult[VoteOptions[WinningVote].announceText]
    local parent = import('/lua/ui/game/borders.lua').GetMapGroup()
    CreateAnnouncement(text1, parent, text2)
    DestroyUI()
end

function AnnounceNewTechAvailable(tech)
    local parent = import('/lua/ui/game/borders.lua').GetMapGroup()
    local text = Config.Text.Announce[tech.AnnounceText]
    CreateAnnouncement(text, parent)
end

-- #### TECH OVER TIME UI STUFF ####

function RefVote(option)
    data = {
        From = GetFocusArmy(),
        To = -1,
        Name = "ReftimeVote",
        Args = { playerName = GetArmiesTable().armiesTable[GetFocusArmy()].nickname, option = option }
    }
    local QueryCb = function() end
    import('/lua/UserPlayerQuery.lua').Query( data, QueryCb )
end

function FSVote(option)
    data2 = {
        From = GetFocusArmy(),
        To = -1,
        Name = "FStimeVote",
        Args = { playerName = GetArmiesTable().armiesTable[GetFocusArmy()].nickname, option = option }
    }
    local QueryCb2 = function() end
    import('/lua/UserPlayerQuery.lua').Query( data2, QueryCb2 )
end

function CreateTTTUI()

    local parent = import('/lua/ui/game/borders.lua').GetMapGroup()

    -- background
    UI = Bitmap(parent, UIUtil.UIFile(Config.Layout.VoteUI.BackgroundTexture))
    UI.Height:Set(function() return Config.Layout.VoteUI.BackgroundHeight end)
    UI.Width:Set(function() return Config.Layout.VoteUI.BackgroundWidth end)
    LayoutHelpers.AtCenterIn(UI, parent, Config.Layout.VoteUI.BackgroundYadj)

    -- title
    UI.title = UIUtil.CreateText(UI, Config.Text.Vote.Dialog.Title, Config.Layout.VoteUI.TitleSize)
    LayoutHelpers.AtTopIn(UI.title, UI, Config.Layout.VoteUI.TitleYadj)
    LayoutHelpers.AtCenterIn(UI.title, UI, -305, 0)

    -- subtext
    UI.subtext = UIUtil.CreateText(UI, Config.Text.Vote.Dialog.Subtitle, Config.Layout.VoteUI.SubtitleSize)
    LayoutHelpers.AtTopIn(UI.subtext, UI, Config.Layout.VoteUI.SubtitleYadj)
    LayoutHelpers.AtCenterIn(UI.subtext, UI, -242, 0)
    -- the counter
    UI.voteTimeLeft = UIUtil.CreateText(UI, "", Config.Layout.VoteUI.CounterSize)
    LayoutHelpers.AtBottomIn(UI.voteTimeLeft, UI, Config.Layout.VoteUI.CounterYadj, Config.Layout.VoteUI.CounterXadj)
	LayoutHelpers.AtCenterIn(UI.voteTimeLeft, UI, 0, 0)
    UI.voteTimeLeft.counterEndSec = GetGameTimeSeconds() + VoteTime


local backMovie 
		local focusarmy = GetFocusArmy()
        local armyInfo = GetArmiesTable()	
	if focusarmy >= 1 then
			if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			backMovie = Movie(UI)
			backMovie:Set('/movies/X06_Rhiza_M02_04487.sfd')
			LayoutHelpers.AtCenterIn(backMovie, UI, -60, 0)
			backMovie:Loop(true)
			backMovie:Play()

			end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
			backMovie = Movie(UI)
			backMovie:Set('/movies/X02_Brackman_M02_03549.sfd')
			LayoutHelpers.AtCenterIn(backMovie, UI, -60, 0)
			backMovie:Loop(true)
			backMovie:Play()
			end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
			backMovie = Movie(UI)
			backMovie:Set('/movies/X01_Graham_M02_03637.sfd')
			LayoutHelpers.AtCenterIn(backMovie, UI, -60, 0)
			backMovie:Loop(true)
			backMovie:Play()
			end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
			backMovie = Movie(UI)
			backMovie:Set('/movies/X04_Oum-Eoshi_M03_03758.sfd')
			LayoutHelpers.AtCenterIn(backMovie, UI, -60, 0)
			backMovie:Loop(true)
			backMovie:Play()
			end
	end


    -- this function updates the counter. But it's only used when the UI is visible (see show/hide functions above)
    UI.voteTimeLeft.UpdateFunc = function()
        local text = string.format( Config.Text.Vote.Dialog.Counter, math.floor(UI.voteTimeLeft.counterEndSec - GetGameTimeSeconds()))
        UI.voteTimeLeft:SetText( text )
    end    

    -- the vote counter
    UI.voteCount = UIUtil.CreateText(UI, string.format(Config.Text.Vote.Dialog.VoteCounter, NumVotesIn), Config.Layout.VoteUI.VoteCounterSize)
    LayoutHelpers.AtCenterIn(UI.voteCount, UI, Config.Layout.VoteUI.VoteCounterYadj, Config.Layout.VoteUI.VoteCounterXadj)

    -- this function updates the counter.
    UI.voteCount.Update = function()
        UI.voteCount:SetText(string.format(Config.Text.Vote.Dialog.VoteCounter, NumVotesIn))
    end

    -- don't show UI just yet!
    UI:Hide()
end

function CreateRefUIButtons()

    if UI then
        UI.buttons = {}
        local i = 1
        local numButtons = table.getn(VoteOptions)
        local firstButtonXadj = math.floor((((
              ( Config.Layout.VoteUI.Button.Width + Config.Layout.VoteUI.Button.Spacing ) * numButtons) - 
                    Config.Layout.VoteUI.Button.Spacing) / -2 ) + Config.Layout.VoteUI.Button.Xadj + 
                   (Config.Layout.VoteUI.Button.Width/2) )

        for k, option in VoteOptions do

            local text = Config.Text.Button[option.btnText]
            local btn = UIUtil.CreateDialogButtonStd(UI, Config.Layout.VoteUI.Button.Texture, text, Config.Layout.VoteUI.Button.TextSize)
			btn.Width:Set(function() return Config.Layout.VoteUI.Button.Width end)
			btn.Height:Set(function() return Config.Layout.VoteUI.Button.Height end)

            if table.getn(UI.buttons) == 0 then
                LayoutHelpers.AtCenterIn( btn, UI, -160, 267)
            else
                LayoutHelpers.Below( btn, UI.buttons[(i-1)], Config.Layout.VoteUI.Button.Spacing)
            end

            btn.OnRolloverEvent = function(self, event)
                if event == 'enter' and Config.Layout.VoteUI.Button.RollOverSound then
                    PlaySound(Sound({Bank = 'Interface', Cue = Config.Layout.VoteUI.Button.RollOverSound}))
                end
            end
            btn.OnClick = function(self, modifiers)
			
                if Config.Layout.VoteUI.Button.OnClickSound then
                    PlaySound(Sound({ Bank = 'Interface', Cue = Config.Layout.VoteUI.Button.OnClickSound }))
                end
                RefVote(self.TTT_VoteOption)
			end

            btn.TTT_VoteOption = k

            UI.buttons[i] = btn
            i = i + 1
        end
    end
end

function CreateFSUIButtons()

    if UI then
        UI.buttons = {}
        local i = 1
        local numButtons = table.getn(VoteOptions2)
        local firstButtonXadj = math.floor((((
              ( Config.Layout.VoteUI.Button.Width + Config.Layout.VoteUI.Button.Spacing ) * numButtons) - 
                    Config.Layout.VoteUI.Button.Spacing) / -2 ) + Config.Layout.VoteUI.Button.Xadj + 
                   (Config.Layout.VoteUI.Button.Width/2) )

        for k, option in VoteOptions2 do

            local text = Config.Text.Button[option.btnText]
            local btn = UIUtil.CreateDialogButtonStd(UI, Config.Layout.VoteUI.Button.Texture, text, Config.Layout.VoteUI.Button.TextSize)
            btn.Width:Set(function() return Config.Layout.VoteUI.Button.Width end)
			btn.Height:Set(function() return Config.Layout.VoteUI.Button.Height end)

            if table.getn(UI.buttons) == 0 then
                LayoutHelpers.AtCenterIn( btn, UI, -160, -267)
            else
                LayoutHelpers.Below( btn, UI.buttons[(i-1)], Config.Layout.VoteUI.Button.Spacing)
            end

            btn.OnRolloverEvent = function(self, event)
                if event == 'enter' and Config.Layout.VoteUI.Button.RollOverSound then
                    PlaySound(Sound({Bank = 'Interface', Cue = Config.Layout.VoteUI.Button.RollOverSound}))
                end
            end
            btn.OnClick = function(self, modifiers)
                if Config.Layout.VoteUI.Button.OnClickSound then
                    PlaySound(Sound({ Bank = 'Interface', Cue = Config.Layout.VoteUI.Button.OnClickSound }))
                end
                FSVote(self.TTT_VoteOption2)
                --UI:Hide()
            end

            btn.TTT_VoteOption2 = k

            UI.buttons[i] = btn
            i = i + 1
        end
    end
end

function CreateOkayButton()

    if UI then
            local text = "Submit"
            local btn = UIUtil.CreateDialogButtonStd(UI, Config.Layout.VoteUI.Button2.Texture, text, 11)
            btn.Width:Set(function() return Config.Layout.VoteUI.Button2.Width end)
			btn.Height:Set(function() return Config.Layout.VoteUI.Button2.Height end)

                LayoutHelpers.AtCenterIn( btn, UI, 0, 140)
               

            btn.OnRolloverEvent = function(self, event)
                if event == 'enter' and Config.Layout.VoteUI.Button2.RollOverSound then
                    PlaySound(Sound({Bank = 'Interface', Cue = Config.Layout.VoteUI.Button2.RollOverSound}))
                end
            end
            btn.OnClick = function(self, modifiers)
                if Config.Layout.VoteUI.Button2.OnClickSound then
                    PlaySound(Sound({ Bank = 'Interface', Cue = Config.Layout.VoteUI.Button2.OnClickSound }))
                end
                AnnounceVoteOver()
                --UI:Hide()
            end
    end
end

function DestroyUI()
    if UI then
        HideVoteUI()
    end
end

function InitTechOverTimeUI()
    if not SessionIsReplay() and not IsObserver() then
        CreateTTTUI()
    end
end


end