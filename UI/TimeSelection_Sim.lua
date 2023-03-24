do

local TTT_Path = import('/lua/game.lua').TTT_ModPath
local Config = import(TTT_Path..'/TimeSelection_Config.lua')
local Votes = {}
local Votes2 = {}
local NumVotingPlayers = 0
local WaitTime = {}
local VoteOver = false
local NumVotesIn = 0
local NumVotesIn2 = 0
-- #### VOTE STUFF ####

local function PlayerVoted(data)

    local playerId = data.From
    local playerName = data.Args.playerName
    local vote = data.Args.option

    if NumVotingPlayers > 0 and ArmyBrains[playerId].BrainType == 'Human' and not ArmyIsOutOfGame(playerId) then

        if Votes[vote] then
            Votes[vote] = Votes[vote] + 1
            NumVotesIn = NumVotesIn + 1
            Sync.TTT_NumVotesIn = NumVotesIn
            if NumVotesIn >= NumVotingPlayers or Votes[vote] > (NumVotingPlayers / 2) then
                EndVote()
            end
        else
            -- unknown or illegal vote
            Sync.TTT_ShowVoteUI = true
        end
    end
end

local function PlayerVoted2(data2)

    local playerId2 = data2.From
    local playerName2 = data2.Args.playerName
    local vote2 = data2.Args.option

    if NumVotingPlayers > 0 and ArmyBrains[playerId2].BrainType == 'Human' and not ArmyIsOutOfGame(playerId2) then

        if Votes2[vote2] then
            Votes2[vote2] = Votes2[vote2] + 1
            NumVotesIn2 = NumVotesIn2 + 1
            Sync.TTT_NumVotesIn2 = NumVotesIn2
            if NumVotesIn2 >= NumVotingPlayers or Votes2[vote2] > (NumVotingPlayers / 2) then
                EndVote2()
            end
        else
            -- unknown or illegal vote
            Sync.TTT_ShowVoteUI = true
        end
    end
end


local function StartVote()

    VoteOver = false

    -- current number of votes for each vote option
    Votes = {}
    for k, v in Config.Vote.VoteOptions do
        Votes[k] = 0
    end

    -- send this stuff to the UI layer
    Sync.TTT_VoteOptions = Config.Vote.VoteOptions
    Sync.TTT_Votes = Votes
    Sync.TTT_VoteTime = Config.Vote.VotingTime

    -- using the query functionality to allow the UI send it's vote back to us
    import('/lua/SimPlayerQuery.lua').AddQueryListener("ReftimeVote", PlayerVoted)

    -- show voting UI for all relevant players
    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
        Sync.TTT_ShowVoteUI = true
    end
    for army, brain in ArmyBrains do
        if brain.BrainType == 'Human' and not ArmyIsOutOfGame(army) then
            NumVotingPlayers = NumVotingPlayers + 1
        end
    end
end

local function StartVote2()

    VoteOver = false

    -- current number of votes for each vote option
	    Votes2 = {}
	for i, j in Config.Vote2.VoteOptions2 do
        Votes2[i] = 0
    end

    -- send this stuff to the UI layer
	    Sync.TTT_VoteOptions2 = Config.Vote2.VoteOptions2
	    Sync.TTT_Votes2 = Votes2
    Sync.TTT_VoteTime = Config.Vote.VotingTime

    -- using the query functionality to allow the UI send it's vote back to us
	import('/lua/SimPlayerQuery.lua').AddQueryListener("FStimeVote", PlayerVoted2)

    -- show voting UI for all relevant players
    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
        Sync.TTT_ShowVoteUI = true
    end
    for army, brain in ArmyBrains do
        if brain.BrainType == 'Human' and not ArmyIsOutOfGame(army) then
            NumVotingPlayers = NumVotingPlayers + 1
        end
    end
end

function EndVote()

    if not VoteOver then

        VoteOver = false

        -- hide vote UI for all players
        for army, brain in ArmyBrains do
            if brain.BrainType == 'Human' then
                Sync.TTT_ShowVoteUI = false
            end
        end

        -- get most voted option
        local winningOption = 0
        for option, numVotes in Votes do
            if numVotes > Votes[winningOption] or not Votes[winningOption] then
                winningOption = option
            end
        end

		selectedreftime = Config.Vote.VoteOptions[winningOption].Interval
		LOG("Ref Points: ", selectedreftime)

        -- tell players what option won the voting
        Sync.TTT_WinningOption = winningOption
        if ArmyBrains[GetFocusArmy()].BrainType == 'Human' or GetFocusArmy() == -1 then
            Sync.TTT_AnnounceVoteOver = false
        end
    end

end

function EndVote2()

    if not VoteOver then

        VoteOver = false

        -- hide vote UI for all players
        for army, brain in ArmyBrains do
            if brain.BrainType == 'Human' then
                Sync.TTT_ShowVoteUI = false
            end
        end

        -- get most voted option
		
		local winningOption2 = 0
        for option2, numVotes2 in Votes2 do
            if numVotes2 > Votes2[winningOption2] or not Votes2[winningOption2] then
                winningOption2 = option2
            end
        end

		selectedfstime = Config.Vote2.VoteOptions2[winningOption2].Interval
				LOG("Tactical Points: ", selectedfstime)	
				
        -- tell players what option won the voting
		Sync.TTT_WinningOption2 = winningOption2
        if ArmyBrains[GetFocusArmy()].BrainType == 'Human' or GetFocusArmy() == -1 then
            Sync.TTT_AnnounceVoteOver = false
        end
    end

end



-- #### TECH OVER TIME STUFF ####



function SetWaitTime( key, voteOption )
    local seconds = voteOption.Interval
    if seconds == -1 then
        seconds = Random( voteOption.Min, voteOption.Max )
    end
    WaitTime[key] = seconds
end

function InitUnlockTechOverTime()



    -- pre-vote time. Don't want to distract users in the first minute
    WaitSeconds(Config.Vote.PreVotingTime)

    -- start vote
    StartVote()
	StartVote2()

    -- wait for voting to complete
    WaitSeconds(Config.Vote.VotingTime)

    -- end vote if it wasn't
    EndVote()
	EndVote2()

    -- adjust T2 wait time because of the 3 minute vote time wait    had to go for this ugly sollution :-(
    for k, v in WaitTime do
        WaitTime[k] = math.max( 0, math.floor( WaitTime[k] - GetGameTimeSeconds()) )
        break
    end

end


end