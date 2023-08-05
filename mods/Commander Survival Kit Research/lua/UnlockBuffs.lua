local Buff = import('/lua/sim/Buff.lua')

local EcoStructureOutputAdd = false
local EcoStructureBuff
local defaultResBuff = 0
local needupdateResBuff = false

local buildratebuffAdd = false
local buildrateBuff
local defaultBRBuff = 0
local needupdateBRBuff = false

local healthbuffAdd = false
local healthBuff
local defaultHPBuff = 0
local needupdateHPBuff = false

local ROFbuffAdd = false
local ROFBuff
local defaultROFBuff = 0
local needupdateROFBuff = false

local DamagebuffAdd = false
local DamageBuff
local defaultDamageBuff = 0
local needupdateDamageBuff = false

local RangebuffAdd = false
local RangeBuff
local defaultRangeBuff = 0
local needupdateRangeBuff = false

local VisionbuffAdd = false
local VisionBuff
local defaultVisionBuff = 0
local needupdateVisionBuff = false

local VeterancybuffAdd = false
local VeterancyBuff
local defaultVeterancyBuff = 0
local needupdateVeterancyBuff = false

local EcoBalUIExActive = true
local EcoBalanceActive = false
local KillAndReclaim = false

local TurnUnitsShieldOn = false
local defaultShieldBuff = 0

local aiThread
local uiThread
local ifnoThread
	
#only human runs these stuffs
BrainCheck = function(brain)
	WaitSeconds(5)
	aiBrain = brain
	ForkThread(EcoStructureAddThread, aiBrain)
	ForkThread(BuildrateBuffThread, aiBrain)
	ForkThread(EcoBalanceExchange, aiBrain)
	ForkThread(KillReclaim, aiBrain)
	ForkThread(ResearchLabAIThread, aiBrain)
end
		
#eco output add toggle
EcoStructureAddToggle = function(data)
    if data != defaultResBuff then
	    needupdateResBuff = true
		defaultResBuff = data
	end
	EcoStructureOutputAdd = true
	EcoStructureBuff = BuffBlueprint {
	    Name = 'EcoStructureBuff',
		DisplayName = 'EcoStructureBuff',
		BuffType = 'RESOURCES',
		Stacks = 'REPLACE',
		Duration = -1,
		Affects = { 
		    MassProduction = {
			    Add = 0,
				Mult = 1 + defaultResBuff, 
			}, 
			EnergyProduction = {
			    Add = 0,
				Mult = 1 + defaultResBuff,
			},
		},
	}
end
	
#buff buildratebuff
BuildratebuffToggle = function(data)
    if data != defaultBRBuff then
	    needupdateBRBuff = true
		defaultBRBuff = data
	end
	buildratebuffAdd = true
	buildrateBuff = BuffBlueprint {
	    Name = 'buildrateBuff',
		DisplayName = 'buildrateBuff',
		BuffType = 'CHEATbuildratebuff',
		Stacks = 'REPLACE',
		Duration = -1,
		Affects = { 
		    BuildRate = {
			    Add = 0,
				Mult = 1 + defaultBRBuff,
			}, 
		},
	}
end
	
#buff health
HealthBuffToggle = function(data)
    if data != defaultHPBuff then
	    needupdateHPBuff = true
		defaultHPBuff = data
	end
	healthbuffAdd = true
	healthBuff = BuffBlueprint {
	    Name = 'healthBuff',
		DisplayName = 'healthBuff',
		BuffType = 'HP',
		Stacks = 'REPLACE',
		Duration = -1,
		Affects = { 
		    Health = {
			    Add = 0,
				Mult = 1 + defaultHPBuff, 
			}, 
			MaxHealth = {
			    Add = 0,
				Mult = 1 + defaultHPBuff, 
			},
		},
	}
end
	
#buff rate of fire
ROFBuffToggle = function(data)
    if data != defaultROFBuff then
	    needupdateROFBuff = true
		defaultROFBuff = data
	end
	ROFbuffAdd = true
	ROFBuff = BuffBlueprint {
	    Name = 'ROFBuff',
		DisplayName = 'ROFBuff',
		BuffType = 'ROF',
		Stacks = 'REPLACE',
		Duration = -1,
		Affects = { 
		    RateOfFire = {
			    Add = 0,
				Mult = 1 - defaultROFBuff,
			}, 
		},
	}
end
	
#damage
DamageBuffToggle = function(data)
    if data != defaultDamageBuff then
	    needupdateDamageBuff = true
		defaultDamageBuff = data
	end
	DamagebuffAdd = true
	DamageBuff = BuffBlueprint {
	    Name = 'DamageBuff',
		DisplayName = 'DamageBuff',
		BuffType = 'DAMAGE',
		Stacks = 'REPLACE',
		Duration = -1,
		Affects = {
		    Damage = {
			    Add = 0,
				Mult = 1 + defaultDamageBuff,
			},   
		},
	}
end
	
#Range
RangeBuffToggle = function(data)
    if data != defaultRangeBuff then
	    needupdateRangeBuff = true
		defaultRangeBuff = data
	end
	RangebuffAdd = true
	RangeBuff = BuffBlueprint {
	    Name = 'RangeBuff',
		DisplayName = 'RangeBuff',
		BuffType = 'RANGE',
		Stacks = 'REPLACE',
		Duration = -1,
		Affects = { 
		    MaxRadius = {
			    Add = 0,
				Mult = 1 + defaultRangeBuff,
			},   
		},
	}
end

#Vision buff
VisionBuffToggle = function(data)
    if data != defaultVisionBuff then
	    needupdateVisionBuff = true
		defaultVisionBuff = data
	end
	VisionbuffAdd = true
	VisionBuff = BuffBlueprint {
	    Name = 'VisionBuff',
		DisplayName = 'VisionBuff',
		BuffType = 'VISION',
		Stacks = 'REPLACE',
		Duration = -1,
		Affects = { 
		    VisionRadius = {
			Add = 0,
			Mult = 1 + defaultVisionBuff,
			}, 
		},
	}
end
	
#Veterancy buff
VeterancyBuffToggle = function(data)
    if data != defaultVeterancyBuff then
	    needupdateVeterancyBuff = true
		defaultVeterancyBuff = data
	end
	VeterancybuffAdd = true
	VeterancyBuff = BuffBlueprint {
	    Name = 'VeterancyBuff',
		DisplayName = 'VeterancyBuff',
		BuffType = 'Veterancy',
		Stacks = 'REPLACE',
		Duration = -1,
		Affects = { 
		    Health = {
			    Add = 0,
				Mult = 1, 
			}, 
			MaxHealth = {
			    Add = 0,
				Mult = 1, 
			},
		},
	}
end

#eco balance toggle from UI option/sound
EcoBalEXUI = function(data)
    if data == true then
	    EcoBalUIExActive = true
	else
	    EcoBalUIExActive = false
	end
end
	
#eco balance toggle
EcoEXToggle = function(data)
    EcoBalanceActive = true
end
			
#kill and get 5% mass toggle
KillReclaimToggle = function(data)
    KillAndReclaim = true
end
		
#Shield buff
ShieldBuffToggle = function(data)
    defaultShieldBuff = data
	TurnUnitsShieldOn = true
end
			
#eco structure add 20/40/60/80/100%
EcoStructureAddThread = function(aiBrain)
    while true do
	    if EcoStructureOutputAdd == true then
		    local buffEcoStructure = aiBrain:GetListOfUnits(categories.ECONOMIC * categories.STRUCTURE - categories.xab1401, false)
			for k,v in buffEcoStructure do
			    if v:GetFractionComplete() == 1 and (not Buff.HasBuff(v, 'EcoStructureBuff') or needupdateResBuff ==  true) then
				    Buff.ApplyBuff(v, 'EcoStructureBuff')
				end
			end
		end
		WaitSeconds(2)
	end
end
	
#buildratebuff add 20/40/60/80/100%
BuildrateBuffThread = function(aiBrain)
    while true do
	    if buildratebuffAdd == true then
		    local builders = aiBrain:GetListOfUnits(categories.CONSTRUCTION + categories.FACTORY + categories.ENGINEER, false)
			for k,v in builders do
			    if v:GetFractionComplete() == 1 and (not Buff.HasBuff(v, 'buildrateBuff') or needupdateBRBuff ==  true) then
				    Buff.ApplyBuff(v, 'buildrateBuff')
				end
			end
		end
		WaitSeconds(2)
	end
end
	
#health add 20/40/60/80/100%
BuffHP = function(unit)
    if healthbuffAdd == true then
	    if not Buff.HasBuff(unit, 'healthBuff') or needupdateHPBuff ==  true then
		    Buff.ApplyBuff(unit, 'healthBuff')
		end
	end
end
	
#rate of fire add 10/25/40/65/100%
BuffROF = function(unit)
    if ROFbuffAdd == true then
	    if not Buff.HasBuff(unit, 'ROFBuff') or needupdateROFBuff ==  true then
		    Buff.ApplyBuff(unit, 'ROFBuff')
		end
	end
end
	
#damage add 20/40/60/80/100%
BuffDamage = function(unit)
    if DamagebuffAdd == true then
	    if not Buff.HasBuff(unit, 'DamageBuff') or needupdateDamageBuff ==  true then
		    Buff.ApplyBuff(unit, 'DamageBuff')
		end
	end
end
	
#range add 10/20/30/40/50%
BuffRange = function(unit)
    if RangebuffAdd == true then
	    if not Buff.HasBuff(unit, 'RangeBuff') or needupdateRangeBuff ==  true then
		    Buff.ApplyBuff(unit, 'RangeBuff')
		end
	end
end
	
#vision add 10/20/30/40/50%
BuffViz = function(unit)
    if VisionbuffAdd == true then
	    if not Buff.HasBuff(unit, 'VisionBuff') or needupdateVisionBuff ==  true then
		    Buff.ApplyBuff(unit, 'VisionBuff')
		end
	end
end
	
#veterancy 1/2/3/4/5
BuffVet = function(unit)
    if VeterancybuffAdd == true then
	    if not Buff.HasBuff(unit, 'VeterancyBuff') or needupdateVeterancyBuff ==  true then
		    Buff.ApplyBuff(unit, 'VeterancyBuff')
			unit:SetVeterancy(defaultVeterancyBuff)
		end
	end
end
	
#eco balance
EcoBalanceExchange = function(aiBrain)
    --FAF 32/3000
    local ratio = 12/3500
	while true do
	    if EcoBalanceActive == true and EcoBalUIExActive == true then
		    local mStorage = aiBrain:GetEconomyStored('MASS')
			local eStorage = aiBrain:GetEconomyStored('ENERGY')
			local mStorageRatio = aiBrain:GetEconomyStoredRatio('MASS')
			local eStorageRatio = aiBrain:GetEconomyStoredRatio('ENERGY')
			local EnergyMaxStored = eStorage/eStorageRatio
			if eStorageRatio > 0.5 and mStorageRatio < 0.9 then
			    local eTake = EnergyMaxStored * 0.2
				local mGive = eTake * ratio
				aiBrain:TakeResource('Energy', eTake)
				aiBrain:GiveResource('Mass', mGive)
			elseif eStorageRatio <= 0.1 and mStorage > 12 then
			    local mTake = 12
				local eGive = mTake / ratio
				aiBrain:TakeResource('Mass', mTake)
				aiBrain:GiveResource('Energy', eGive)
			end
		end
		WaitSeconds(0.5)
	end	
end
	
KillReclaim = function(aiBrain)
    local killMult = 0.05
	local oldMass = aiBrain:GetArmyStat("Enemies_MassValue_Destroyed",0.0).Value
	local massAdd
	while true do
	    if KillAndReclaim == true then
		    local newMass = aiBrain:GetArmyStat("Enemies_MassValue_Destroyed",0.0).Value
			massAdd = 0
			if newMass > oldMass then
			    #mass income from kills
				massAdd = (newMass - oldMass) * killMult
			end
			#show income from kills, happy now!
			aiBrain:GiveResource('Mass', massAdd)
			#reset the parameters
			oldMass = newMass
		end
		WaitSeconds(1)
	end
end
			
GiveResourceMass = function(data)
    aiBrain:GiveResource(data.id, data.qty)
end
	
#unit shield on
ActiveUnitShield = function(unit)
    if TurnUnitsShieldOn == true then  
	    local mHealth, shieldSpec = GenerateShieldSpec(unit)
		#shield on
		if not unit:ShieldIsOn() then
		    TakeEnergy(unit, mHealth)
			unit:CreatePersonalShield(shieldSpec)
			local bpEcon = unit:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy
			if not bpEcon then
    			#unit with energy consumption will recover its shield
				unit:SetEnergyMaintenanceConsumptionOverride(10)
				unit:SetConsumptionActive(true)
			end
			#show gamer its shield health
			#local id = unit:GetEntityId()
			#FloatingEntityText(id, math.floor(mHealth))
		end
	end
end
	
GenerateShieldSpec = function(unit)
    local bp = unit:GetBlueprint()
	local FactionName = bp.General.FactionName
	local unitId = unit:GetUnitId()
	local mHealth = bp.Defense.MaxHealth * defaultShieldBuff
	local OwnerShieldMeshPath = '/mods/Commander Survival Kit Research/PersonalShieldMesh/'..FactionName..'/'..unitId..'_PhaseShield_mesh'
	
	#Personal shield spec.
	local Shield = {
	    ImpactEffects = FactionName..'ShieldHit01',
		OwnerShieldMesh = OwnerShieldMeshPath,
		PersonalShield = true,
		RegenAssistMult = 60,
		ShieldEnergyDrainRechargeTime = 5,
		ShieldMaxHealth = math.floor(mHealth),
		ShieldRechargeTime = 60,
		ShieldRegenRate = 3,
		ShieldRegenStartTime = 5,
		ShieldSize = 2.5,
		ShieldVerticalOffset = 0,
	}
	
	return mHealth, table.deepcopy(Shield)
end
	
TakeEnergy = function(unit, mHealth)
    local aiBrain = unit:GetAIBrain()
	local have = aiBrain:GetEconomyStored('ENERGY')
	#Titan personal shield 2200 requires 25 energy
	local need = math.floor(mHealth / 88)
	if not ( have > need ) then
	    return
	end
	# Drain economy here
	aiBrain:TakeResource( 'ENERGY', need )
end

	
ResearchLabUIThread = function()
    uiThread = ForkThread(function() 
	    while true do
    		local labs = aiBrain:GetListOfUnits(categories.RESEARCHCENTER, false)
			if labs then
			    if table.getn(labs) > 0 then
				    for k,v in labs do
					    if v:GetFractionComplete() == 1 then
						    Sync.HasResearchLab = true
							if not ifnoThread then
							    ForkThread(IfNoResearchLabThread, aiBrain)
							end
							KillThread(uiThread)
							uiThread = nil
						end
					end
				end
			end
			WaitSeconds(1)
		end
	end)
end

ResearchLabAIThread = function(self)
    aiThread = ForkThread(function() 
	    while true do
		    local labs = self:GetListOfUnits(categories.RESEARCHCENTER, false)
			if labs then
			    if table.getn(labs) > 0 then
				    for k,v in labs do
					    if v:GetFractionComplete() == 1 then
						    Sync.HasResearchLab = true
							if not ifnoThread then
							    ForkThread(IfNoResearchLabThread, self)
							end
							KillThread(aiThread)
							aiThread = nil
						end
					end
				end
			end
			WaitSeconds(1)
		end
	end)
end
	
IfNoResearchLabThread = function(self)
    ifnoThread = ForkThread(function()
	    while true do
		    local labs = self:GetListOfUnits(categories.RESEARCHCENTER, false)
			if labs then
			    if table.getn(labs) == 0 then
				    Sync.LostResearchLab = true
					if not aiThread then
					    ForkThread(ResearchLabAIThread, self)
					end
					KillThread(ifnoThread)
					ifnoThread = nil
				end
			end
			WaitSeconds(2)
		end
	end)
end
	