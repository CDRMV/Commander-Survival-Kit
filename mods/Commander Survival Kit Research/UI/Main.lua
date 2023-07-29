
local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Button = import('/lua/maui/button.lua').Button
local Prefs = import('/lua/user/prefs.lua')
local Tooltip = import('/lua/ui/game/tooltip.lua')
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local CreateWindow = import('/lua/maui/window.lua').Window

local abilityUpdateThread = false
local abilityText = false

#initial abilities for a new game
local ResearchPointsAmount = 0
local ResearchPointsGenerated = 0
local ResearchPointsCollected = 0
local AbilitySpent = 0

#enhancement panel
ResBuffTable = {1}
BalanceThread = false
KillReclaimThread = false
BuildrateBuffTable = {1}
GameHasResearchLab = false
HealthBuffTable = {1}
ROFBuffTable = {1}
DamageBuffTable = {1}
RangeBuffTable = {1}
VisionBuffTable = {1}
VeterancyBuffTable = {1}
ShieldBuffTable = {1}

#intel panel
BaseDroneActive = false
FogOfWarCountTable = {1}
ExpAlertThread = false

#field panel
AllFactionEng = false
AllFactionSub = false

function ResearchLabHandle(generated)
	ForkThread(function()
		ResearchPointsGenerated = generated + ResearchPointsGenerated
		LOG('ResearchPoints:', ResearchPointsGenerated)
	end)
end 

function CollectedAbility(Collected)
	ResearchPointsCollected = Collected + ResearchPointsGenerated
end

function SpentAbility(Spent)
	AbilitySpent = Spent
end

    
	
	local dialog = false
    if dialog then
	    dialog:Destroy()
    end

    -- lots of state
    local function KillDialog()

        if over then
            dialog:Destroy()
        else
        end
    end
    
	Border = {
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
		Left = 345, 
		Top = 8, 
		Bottom = 72, 
		Right = 480
	}

    local skin = UIUtil.UIFile('/game/avatar/pulse-bars_bmp.dds')
	--dialog = Bitmap(GetFrame(0), UIUtil.UIFile('/mods/Research/textures/ui/common/panel/bg4.png'))
	
	dialog = CreateWindow(GetFrame(0),nil,nil,false,false,true,true,'Construction',Position,Border) 
	dialog._closeBtn:Hide()
	--dialog.Width:Set(700)
	--dialog.Height:Set(30)
    --LayoutHelpers.AtTopIn(dialog, GetFrame(0), 0)
	--LayoutHelpers.AtLeftTopIn(dialog, GetFrame(0), 340, 7)
	for i, v in Position do 
		dialog[i]:Set(v)
	end
    local skin = UIUtil.UIFile('/mods/Commander Survival Kit Research/textures/uef_researchbutton_up.dds')
    abilityButton = Button(dialog,skin,skin,skin,skin)
	abilityButton.Width:Set(70)
	abilityButton.Height:Set(70)
	LayoutHelpers.AtLeftTopIn(abilityButton, dialog, -5, -4)
	LayoutHelpers.DepthOverParent(abilityButton, dialog, 10)
	--btnbordertex = UIUtil.UIFile('/game/avatar/pulse-bars_bmp.dds')
	--btnborder = Bitmap(abilityButton, btnbordertex)
	--btnborder.Width:Set(80)
	--btnborder.Height:Set(80)
	--LayoutHelpers.AtLeftTopIn(btnborder, abilityButton, 0, -1)
	--LayoutHelpers.DepthOverParent(btnborder, abilityButton, 0)
	
	ForkThread(function()
		SavedGameHandle()
	end)
	
	
    abilityText = UIUtil.CreateText(dialog, LOC(ResearchPointsAmount), 22)
	LayoutHelpers.AtLeftTopIn(abilityText, dialog, 80, 27)
	LayoutHelpers.DepthOverParent(abilityText, dialog, 10)
	Tooltip.AddButtonTooltip(abilityButton, "<LOC AB_Research>Click to show research panel")
		
	ForkThread(function()
		while abilityButton do
		    UpdateAbilityScore()
			WaitSeconds(1)
		end
	end)
	
	abilityButton.OnClick = function()
	    import('/mods/Commander Survival Kit Research/ui/ResearchUI.lua').CreateDialog(GetFrame(0), ResearchPointsAmount)
	end

	
function UpdateAbilityScore()
    local leftAbilities = ResearchPointsAmount + ResearchPointsCollected - AbilitySpent
	Prefs.SetToCurrentProfile("AbilityResearch_Ability_Storage", leftAbilities)
	Prefs.SavePreferences()
	local abilityScore = leftAbilities
	#max show 99, more than it still can be spent
	if leftAbilities > 99 then
	    abilityScore = 99
	end
    abilityText:SetText(abilityScore)
	abilityText:SetColor('ffFFFFFF')
end

function InsufficientAB()
	ForkThread(function()
	    abilityText:SetColor('Red')
		WaitSeconds(.2)
		abilityText:SetColor('FFa4ff00')
		WaitSeconds(.2)
		abilityText:SetColor('Red')
		WaitSeconds(.2)
		abilityText:SetColor('FFa4ff00')
	end)
end

function SaveResearchStatus()
	ForkThread(function()
	    #blue color, if abilityText becomes blue, that means quick saving...
		abilityText:SetColor('00a4ff')
		#after saving font color back to default
	    WaitSeconds(1)
	    abilityText:SetColor(UIUtil.fontColor)
	end)
	Prefs.SetToCurrentProfile("Research_Enh_ResBuff_Table", ResBuffTable)
	Prefs.SetToCurrentProfile("Research_Enh_BuildrateBuff_Table", BuildrateBuffTable)
	Prefs.SetToCurrentProfile("Research_Enh_HealthBuff_Table", HealthBuffTable)
	Prefs.SetToCurrentProfile("Research_Enh_ROFBuff_Table", ROFBuffTable)
	Prefs.SetToCurrentProfile("Research_Enh_DamageBuff_Table", DamageBuffTable)
	Prefs.SetToCurrentProfile("Research_Enh_RangeBuff_Table", RangeBuffTable)
	Prefs.SetToCurrentProfile("Research_Enh_VisionBuff_Table", VisionBuffTable)
	Prefs.SetToCurrentProfile("Research_Enh_VeterancyBuff_Table", VeterancyBuffTable)
	Prefs.SetToCurrentProfile("Research_Enh_ShieldBuff_Table", ShieldBuffTable)
	Prefs.SavePreferences()
end

function SavedGameHandle()
    #load our last saving game's settings
    if import('/lua/ui/game/gamemain.lua').IsSavedGame == true then
		ResearchPointsAmount = Prefs.GetFromCurrentProfile("AbilityResearch_Ability_Storage")
		
		#enh panel
		ResBuffTable = Prefs.GetFromCurrentProfile("Research_Enh_ResBuff_Table")
		BalanceThread = Prefs.GetFromCurrentProfile("Research_Enh_Balace_Thread")
		KillReclaimThread = Prefs.GetFromCurrentProfile("Research_Enh_KC_Thread")
		BuildrateBuffTable = Prefs.GetFromCurrentProfile("Research_Enh_BuildrateBuff_Table")
		GameHasResearchLab = Prefs.GetFromCurrentProfile("Research_Enh_Lab_Thread")
		SimCallback({Func = 'GameHasResearchLabThread'})
		HealthBuffTable = Prefs.GetFromCurrentProfile("Research_Enh_HealthBuff_Table")
		ShieldBuffTable = Prefs.GetFromCurrentProfile("Research_Enh_ShieldBuff_Table")
		ROFBuffTable = Prefs.GetFromCurrentProfile("Research_Enh_ROFBuff_Table")
		DamageBuffTable = Prefs.GetFromCurrentProfile("Research_Enh_DamageBuff_Table")
		RangeBuffTable = Prefs.GetFromCurrentProfile("Research_Enh_RangeBuff_Table")
		VisionBuffTable = Prefs.GetFromCurrentProfile("Research_Enh_VisionBuff_Table")
		VeterancyBuffTable = Prefs.GetFromCurrentProfile("Research_Enh_VeterancyBuff_Table")
		
		#intel panel
		BaseDroneActive = Prefs.GetFromCurrentProfile("Research_Intel_BD_Thread")
		FogOfWarCountTable = Prefs.GetFromCurrentProfile("Research_Intel_Fog_Table")
		ExpAlertThread = Prefs.GetFromCurrentProfile("Research_Intel_ExpAlert_Thread")
		
		#field panel
		AllFactionEng = Prefs.GetFromCurrentProfile("Research_Intel_AllFactionEng")
		AllFactionSub = Prefs.GetFromCurrentProfile("Research_Intel_AllFactionSub")
    else
	    #reset icon status to default if a new game
		Prefs.SetToCurrentProfile("AbilityResearch_Ability_Storage", ResearchPointsAmount)
		
		#enh panel
		Prefs.SetToCurrentProfile("Research_Enh_ResBuff_Table", ResBuffTable)
		Prefs.SetToCurrentProfile("Research_Enh_Balace_Thread", BalanceThread)
		Prefs.SetToCurrentProfile("Research_Enh_KC_Thread", KillReclaimThread)
		Prefs.SetToCurrentProfile("Research_Enh_BuildrateBuff_Table", BuildrateBuffTable)
		Prefs.SetToCurrentProfile("Research_Enh_Lab_Thread", GameHasResearchLab)
		Prefs.SetToCurrentProfile("Research_Enh_HealthBuff_Table", HealthBuffTable)
		Prefs.SetToCurrentProfile("Research_Enh_ShieldBuff_Table", ShieldBuffTable)
		Prefs.SetToCurrentProfile("Research_Enh_ROFBuff_Table", ROFBuffTable)
		Prefs.SetToCurrentProfile("Research_Enh_DamageBuff_Table", DamageBuffTable)
		Prefs.SetToCurrentProfile("Research_Enh_RangeBuff_Table", RangeBuffTable)
		Prefs.SetToCurrentProfile("Research_Enh_VisionBuff_Table", VisionBuffTable)
		Prefs.SetToCurrentProfile("Research_Enh_VeterancyBuff_Table", VeterancyBuffTable)
		
		#intel panel
		Prefs.SetToCurrentProfile("Research_Intel_BD_Thread", BaseDroneActive)
		Prefs.SetToCurrentProfile("Research_Intel_Fog_Table", FogOfWarCountTable)
		Prefs.SetToCurrentProfile("Research_Intel_ExpAlert_Thread", ExpAlertThread)
		
		#field panel
		Prefs.SetToCurrentProfile("Research_Intel_AllFactionEng", AllFactionEng)
		Prefs.SetToCurrentProfile("Research_Intel_AllFactionSub", AllFactionSub)
		Prefs.SavePreferences()
    end
end
