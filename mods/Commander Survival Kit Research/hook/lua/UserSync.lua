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
	
	# abilities from research labs
	if Sync.ResearchCentersCount then
		import('/Mods/Commander Survival Kit Research/UI/Main.lua').ResearchLabHandle(Sync.ResearchCentersCount)
		import('/Mods/Commander Survival Kit Research/UI/ResearchUI.lua').ResearchLabHandle(Sync.ResearchCentersCount)
		import('/Mods/Commander Survival Kit Research/UI/CTechnologyResearchTree.lua').ResearchLabHandle(Sync.ResearchCentersCount)
		import('/Mods/Commander Survival Kit Research/UI/TTechnologyResearchTree.lua').ResearchLabHandle(Sync.ResearchCentersCount)
		--import('/Mods/Research/lua/ui/EnhPanel.lua').ResearchLabHandle(Sync.ResearchLabsCount)
		--import('/Mods/Research/lua/ui/FieldPanel.lua').ResearchLabHandle(Sync.ResearchLabsCount)
		--import('/Mods/Research/lua/ui/IntelPanel.lua').ResearchLabHandle(Sync.ResearchLabsCount)
		--import('/Mods/Research/lua/ui/SWPPanel.lua').ResearchLabHandle(Sync.ResearchLabsCount)
	end
	
	if Sync.PointInvestment then
		import('/Mods/Commander Survival Kit Research/UI/Main.lua').ResearchPointInvestmentHandle(Sync.PointInvestment)
		import('/Mods/Commander Survival Kit Research/UI/ResearchUI.lua').ResearchPointInvestmentHandle(Sync.PointInvestment)
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
