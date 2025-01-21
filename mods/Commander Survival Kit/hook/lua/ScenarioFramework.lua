local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 


do
function SetPlayableArea( rect, voFlag )
     if (voFlag == nil) then
         voFlag = true
    end
    if type(rect) == 'string' then
        rect = ScenarioUtils.AreaToRect(rect)
    end

    local x0 = rect.x0 - math.mod(rect.x0 , 4)
    local y0 = rect.y0 - math.mod(rect.y0 , 4)
    local x1 = rect.x1 - math.mod(rect.x1, 4)
    local y1 = rect.y1 - math.mod(rect.y1, 4) 

    LOG(string.format('Debug: SetPlayableArea before round : %s,%s %s,%s',rect.x0,rect.y0,rect.x1,rect.y1))
    LOG('Hook SetPlayableArea')
	
	if ScenarioInfo.type == 'campaign' or ScenarioInfo.type == 'campaign_coop' then
	
	elseif ScenarioInfo.type == 'skirmish' then
	if x0 >= 0 then
		x0 = 5
	end

	if y0 >= 0 then
		y0 = 5
	end
	
	if x1 >= 0 then
		x1 = ScenarioInfo.size[1] - 5
	end

	if y1 >= 0 then
		y1 = ScenarioInfo.size[2] - 5
	end
	end
	
	LOG(string.format('Debug: SetPlayableArea after round : %s,%s %s,%s',x0,y0,x1,y1))
	
    ScenarioInfo.MapData.PlayableRect = {x0,y0,x1,y1}
    rect.x0 = x0
    rect.x1 = x1
    rect.y0 = y0
    rect.y1 = y1

    SetPlayableRect( x0, y0, x1, y1 )
    if voFlag then
        ForkThread(PlayableRectCameraThread, rect)
        table.insert(Sync.Voice, {Cue='Computer_Computer_MapExpansion_01380', Bank='XGG'} )
    end

    import('/lua/SimSync.lua').SyncPlayableRect(rect)
end


end


else

do

function SetPlayableArea(rect, voFlag)
    if voFlag == nil then
        voFlag = true
    end

    if type(rect) == 'string' then
        rect = ScenarioUtils.AreaToRect(rect)
    end

    local x0 = rect.x0 - math.mod(rect.x0 , 4)
    local y0 = rect.y0 - math.mod(rect.y0 , 4)
    local x1 = rect.x1 - math.mod(rect.x1, 4)
    local y1 = rect.y1 - math.mod(rect.y1, 4)

    SPEW(string.format('SetPlayableArea before round : %s, %s %s, %s', rect.x0, rect.y0, rect.x1, rect.y1))
    SPEW('Hook SetPlayableArea')
	
	if ScenarioInfo.type == 'campaign' or ScenarioInfo.type == 'campaign_coop' then
	
	elseif ScenarioInfo.type == 'skirmish' then
	if x0 >= 0 then
		x0 = 5
	end

	if y0 >= 0 then
		y0 = 5
	end
	
	if x1 >= 0 then
		x1 = ScenarioInfo.size[1] - 5
	end

	if y1 >= 0 then
		y1 = ScenarioInfo.size[2] - 5
	end
	end

	SPEW(string.format('SetPlayableArea after round : %s, %s %s, %s', x0, y0, x1, y1))
	
    ScenarioInfo.MapData.PlayableRect = {x0, y0, x1, y1}
    rect.x0 = x0
    rect.x1 = x1
    rect.y0 = y0
    rect.y1 = y1

    SetPlayableRect(x0, y0, x1, y1)
    if voFlag then
        ForkThread(PlayableRectCameraThread, rect)
        SyncVoice({Cue = 'Computer_Computer_MapExpansion_01380', Bank = 'XGG'})
    end

    import("/lua/simsync.lua").SyncPlayableRect(rect)
    Sync.NewPlayableArea = {x0, y0, x1, y1}
    ForkThread(GenerateOffMapAreas)
end

end

end
