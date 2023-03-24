do

local TTT_Path = import('/lua/game.lua').TTT_ModPath
local TTTUIFile = TTT_Path..'/TimeSelection.lua'
local oldOnSync = OnSync
function OnSync()
    oldOnSync()

    if Sync.TTT_VoteOptions then
        import(TTTUIFile).SetVoteOptions( Sync.TTT_VoteOptions )
    end
	if Sync.TTT_VoteOptions2 then
        import(TTTUIFile).SetVoteOptions2( Sync.TTT_VoteOptions2 )
    end
    if Sync.TTT_Votes then
        import(TTTUIFile).SetVotes( Sync.TTT_Votes )
    end
	if Sync.TTT_Votes2 then
        import(TTTUIFile).SetVotes( Sync.TTT_Votes2 )
    end
    if Sync.TTT_VoteTime then
        import(TTTUIFile).SetVoteTime( Sync.TTT_VoteTime)
    end
    if Sync.TTT_NumVotesIn then
        import(TTTUIFile).SetNumVotesIn( Sync.TTT_NumVotesIn)
    end
	    if Sync.TTT_NumVotesIn2 then
        import(TTTUIFile).SetNumVotesIn2( Sync.TTT_NumVotesIn2)
    end
    if Sync.TTT_ShowVoteUI != nil then
        if Sync.TTT_ShowVoteUI == true then
            import(TTTUIFile).ShowVoteUI()
        else
            import(TTTUIFile).HideVoteUI()
        end
    end
    if Sync.TTT_WinningOption then
        import(TTTUIFile).SetWinningVote( Sync.TTT_WinningOption )
    end
	if Sync.TTT_WinningOption2 then
        import(TTTUIFile).SetWinningVote2( Sync.TTT_WinningOption2 )
    end
    if Sync.TTT_AnnounceVoteOver then
        import(TTTUIFile).AnnounceVoteOver()
    end
    if Sync.TTT_AnnounceNewTechAvailable then
        import(TTTUIFile).AnnounceNewTechAvailable(Sync.TTT_AnnounceNewTechAvailable)
    end
end


end