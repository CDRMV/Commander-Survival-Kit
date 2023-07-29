#****************************************************************************
#**
#**  File     :  /hook/lua/UserSync.lua
#**  Author(s):  novaprim3
#**
#**  Summary  :  Multi-Phantom Mod for Forged Alliance
#**
#****************************************************************************

local ResearchOnSync = OnSync
function OnSync()
	ResearchOnSync ()
	
	# research abilities from kill counts
	if Sync.ResearchUpdatedAbilityCount then
		import('/Mods/Commander Survival Kit Research/UI/Main.lua').CollectedAbility(Sync.ResearchUpdatedAbilityCount)
		--import('/Mods/Research/lua/ui/EnhPanel.lua').CollectedAbility(Sync.ResearchUpdatedAbilityCount)
		--import('/Mods/Research/lua/ui/FieldPanel.lua').CollectedAbility(Sync.ResearchUpdatedAbilityCount)
		--import('/Mods/Research/lua/ui/IntelPanel.lua').CollectedAbility(Sync.ResearchUpdatedAbilityCount)
		--import('/Mods/Research/lua/ui/SWPPanel.lua').CollectedAbility(Sync.ResearchUpdatedAbilityCount)
	end
	
	# abilities from research labs
	if Sync.ResearchCentersCount then
		import('/Mods/Commander Survival Kit Research/UI/Main.lua').ResearchLabHandle(Sync.ResearchCentersCount)
		--import('/Mods/Research/lua/ui/EnhPanel.lua').ResearchLabHandle(Sync.ResearchLabsCount)
		--import('/Mods/Research/lua/ui/FieldPanel.lua').ResearchLabHandle(Sync.ResearchLabsCount)
		--import('/Mods/Research/lua/ui/IntelPanel.lua').ResearchLabHandle(Sync.ResearchLabsCount)
		--import('/Mods/Research/lua/ui/SWPPanel.lua').ResearchLabHandle(Sync.ResearchLabsCount)
	end
	
--[[	
	# once Research Lab is online, gatling bot square reinforecement starts preparing
	if Sync.HasResearchLab == true then
        local parent = import('/lua/ui/game/borders.lua').GetMapGroup() 
		import('/mods/Research/lua/ui/Reinforcement.lua').CreateUI(parent)
	end
	
	# research labs destroyed
	if Sync.LostResearchLab == true then
		import('/mods/Research/lua/ui/Reinforcement.lua').KillPanel()
	end
	
	# map size viz off
	if Sync.NotifyVizOff then
	    import('/mods/Research/lua/ui/IntelPanel.lua').MapSizeVizCountDown(Sync.NotifyVizOff)
	end
--]]	
end
