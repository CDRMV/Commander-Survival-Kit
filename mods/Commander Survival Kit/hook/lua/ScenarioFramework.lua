local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 
if DiskGetFileInfo('/lua/AI/CustomAIs_v2/ExtrasAI.lua') then
if import('/lua/AI/CustomAIs_v2/ExtrasAI.lua').AI.Name == 'AI Patch LOUD' then

do
function SetPlayableArea( rect, voFlag )

    if ScenarioInfo.Playablearea then
        LOG("*AI DEBUG reported current playable area is "..repr(ScenarioInfo.Playablearea).." processing area "..repr(rect) )
    end

	local function GenerateOffMapAreas()
    
		local playablearea = {}

        -- this value is only present if we sucessfully set a restricted
        -- playable area -- otherwise we use map dimensions --
		if  ScenarioInfo.MapData.PlayableRect then
        
			playablearea = ScenarioInfo.MapData.PlayableRect
       
		else
        
            LOG("*AI DEBUG No playable area was defined - using map size")
            
			playablearea = {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
            ScenarioInfo.MapData.PlayableRect = playablearea
		end

		ScenarioInfo.Playablearea = playablearea
        
		LOG('playable area coordinates are ' .. repr(playablearea))

	end
	
    if (voFlag == nil) then
        voFlag = true
    end

    -- if this is a name - and not a table - convert it into a table using the name
    if type(rect) == 'string' then

        local area = ScenarioInfo.Env.Scenario.Areas[rect]
    
        if not area then
            error('ERROR: Invalid area name '..repr(rect) )
            return
        end
    
        local rectangle = area.rectangle
        
        rect = Rect(rectangle[1],rectangle[2],rectangle[3],rectangle[4])    

    end

    LOG(string.format('Debug: SetPlayableArea before round : %s,%s %s,%s',rect.x0,rect.y0,rect.x1,rect.y1))
    
    local x0 = rect.x0 + math.mod(rect.x0 , 3)
    local y0 = rect.y0 + math.mod(rect.y0 , 3)
    local x1 = rect.x1 - math.mod(rect.x1, 3)
    local y1 = rect.y1 - math.mod(rect.y1, 3)

	if not ScenarioInfo.MapData then
		ScenarioInfo.MapData = {}
	end
	
	if ScenarioInfo.type == 'campaign' or ScenarioInfo.type == 'campaign_coop' then
	LOG(string.format('Debug: SetPlayableArea after round : %s,%s %s,%s',x0,y0,x1,y1))

    rect.x0 = x0
    rect.x1 = x1
    rect.y0 = y0
    rect.y1 = y1

    if x1 != 0 and y1 != 0 then
    
        SetPlayableRect( x0, y0, x1, y1 )
	
        if voFlag then
            ForkThread(PlayableRectCameraThread, rect)
            table.insert(Sync.Voice, {Cue='Computer_Computer_MapExpansion_01380', Bank='XGG'} )
        end

        import('/lua/SimSync.lua').SyncPlayableRect(rect)
    
        Sync.NewPlayableArea = {x0, y0, x1, y1}
	
        ScenarioInfo.MapData.PlayableRect = {x0,y0,x1,y1}
    
    end
    
	GenerateOffMapAreas()
	elseif ScenarioInfo.type == 'skirmish' then
	if ScenarioInfo.MapData.PlayableRect then
	
	else
	
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
	
    LOG(string.format('Debug: SetPlayableArea after round : %s,%s %s,%s',x0,y0,x1,y1))

    rect.x0 = x0
    rect.x1 = x1
    rect.y0 = y0
    rect.y1 = y1

    if x1 != 0 and y1 != 0 then
    
        SetPlayableRect( x0, y0, x1, y1 )
	
        if voFlag then
            ForkThread(PlayableRectCameraThread, rect)
            table.insert(Sync.Voice, {Cue='Computer_Computer_MapExpansion_01380', Bank='XGG'} )
        end

        import('/lua/SimSync.lua').SyncPlayableRect(rect)
    
        Sync.NewPlayableArea = {x0, y0, x1, y1}
	
        ScenarioInfo.MapData.PlayableRect = {x0,y0,x1,y1}
    
    end
    
	GenerateOffMapAreas()
	end
	end
end

end

end

else

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
	elseif ScenarioInfo.type == 'skirmish' then
	if ScenarioInfo.MapData.PlayableRect then
	
	else
	
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
end


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
	elseif ScenarioInfo.type == 'skirmish' then
	
	if ScenarioInfo.MapData.PlayableRect then
	
	else
	
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

end

end
