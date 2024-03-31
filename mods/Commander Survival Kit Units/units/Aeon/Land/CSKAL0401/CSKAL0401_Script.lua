#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0303/UAL0303_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local ADFLaserHighIntensityWeapon = import('/lua/aeonweapons.lua').ADFLaserHighIntensityWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local EffectTemplate = import('/lua/EffectTemplates.lua')

CSKAL0401 = Class(AWalkingLandUnit) {   
	decal = nil, 
    Weapons = {
        FrontTurret01 = Class(ADFLaserHighIntensityWeapon) {}
    },
    
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateAeonCommanderBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
    end,  
	
	CreateOuterRingWaveSmokeRing = function(self) 
        local sides = 32
        local angle = (2*math.pi) / sides
        local velocity = 7
        local OffsetMod = 8
        local projectiles = {}

        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            local proj =  self:CreateProjectile('/effects/entities/UEFNukeShockwave02/UEFNukeShockwave02_proj.bp', X * OffsetMod , 2.5, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity)
            table.insert( projectiles, proj )
        end  
        
        WaitSeconds( 3 )

        # Slow projectiles down to normal speed
        for k, v in projectiles do
            v:SetAcceleration(-0.45)
        end         
    end, 
	
	CreateGroundPlumeConvectionEffects = function(self,army)
    for k, v in EffectTemplate.TNukeGroundConvectionEffects01 do
          CreateEmitterAtEntity(self, army, v ) 
    end
    
    local sides = 10
    local angle = (2*math.pi) / sides
    local inner_lower_limit = 2
        local outer_lower_limit = 2
        local outer_upper_limit = 2
    
    local inner_lower_height = 1
    local inner_upper_height = 3
    local outer_lower_height = 2
    local outer_upper_height = 3
      
    sides = 8
    angle = (2*math.pi) / sides
    for i = 0, (sides-1)
    do
        local magnitude = RandomFloat(outer_lower_limit, outer_upper_limit)
        local x = math.sin(i*angle+RandomFloat(-angle/2, angle/4)) * magnitude
        local z = math.cos(i*angle+RandomFloat(-angle/2, angle/4)) * magnitude
        local velocity = RandomFloat( 1, 3 ) * 3
        self:CreateProjectile('/effects/entities/UEFNukeEffect05/UEFNukeEffect05_proj.bp', x, RandomFloat(outer_lower_height, outer_upper_height), z, x, 0, z)
            :SetVelocity(x * velocity, 0, z * velocity)
    end 
    end,
	
	OnCreate = function(self)
        AWalkingLandUnit.OnCreate(self)
		self:RemoveToggleCap('RULEUTC_ShieldToggle')
		self:DestroyShield()
		local army = self:GetArmy()
		local position = self:GetPosition()
		local orientation = 0
		decal = CreateDecal(position, orientation, '/mods/Commander Survival Kit Units/icons/aeon_symbol.dds', '', 'Albedo', 15, 15, 500, 600, army)
		self.ArmSlider1 = CreateSlider(self, 'Body')
        self.Trash:Add(self.ArmSlider1)
		self.ArmSlider1:SetGoal(0, 1000, 0)
		self.ArmSlider1:SetSpeed(1000)
		self:HideBone('Body', true) 
		self:HideBone('Shield', true)
        self:SetUnSelectable(true)	
        self:HideBone('Leg01_Turret', true)
        self:HideBone('Leg02_Turret', true)        
        self:HideBone('Leg03_Turret', true)   
        self:HideBone('Leg04_Turret', true) 
        self:HideBone('L_Turret00', true)
        self:HideBone('L_Turret01', true)        
        self:HideBone('R_Turret00', true)   
        self:HideBone('R_Turret01', true) 
    end,
	
	
	 OnStopBeingBuilt = function(self,builder,layer)
        AWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		decal:Destroy()
		self:RemoveToggleCap('RULEUTC_ShieldToggle')
		self:DestroyShield()
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(0)		
		local army = self:GetArmy()
        local position = self:GetPosition()
		local orientation = RandomFloat(0,2*math.pi)
        self:ForkThread(function() 
		WaitSeconds(5)			
		self.ArmSlider1 = CreateSlider(self, 'Body')
		self.Trash:Add(self.ArmSlider1)
		self.ArmSlider1:SetGoal(0, -1000, 0)
		self.ArmSlider1:SetSpeed(500)
		self:ShowBone('Body', true) 
		self:HideBone('Shield', true)
        self:HideBone('Leg01_Turret', true)
        self:HideBone('Leg02_Turret', true)        
        self:HideBone('Leg03_Turret', true)   
        self:HideBone('Leg04_Turret', true) 
        self:HideBone('L_Turret00', true)
        self:HideBone('L_Turret01', true)        
        self:HideBone('R_Turret00', true)   
        self:HideBone('R_Turret01', true)  
		WaitSeconds(2)			
        DamageRing(self, position, .1, 11, 100, 'Force', false, false)
		# Knockdown force rings
        DamageRing(self, position, 11, 20, 1, 'Force', false, false)
        DamageRing(self, position, 11, 20, 1, 'Force', false, false)
        CreateDecal(position, orientation, 'Scorch_010_albedo', '', 'Albedo', 28, 28, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 28, 28, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 12, 12, 500, 600, army)
		if self.AnimationManipulator then
            self:ForkThread(function()
				self.AnimationManipulator:SetRate(0.1)
                WaitSeconds(15)
                self.AnimationManipulator:Destroy()
				self:SetUnSelectable(false)	
            end)
        end		
		self:CreateGroundPlumeConvectionEffects()		
		self:CreateOuterRingWaveSmokeRing()	
        # Scorch decal and light some trees on fire
        DamageRing(self, position, 20, 27, 1, 'Fire', false, false)
		local bp = self:GetBlueprint()
        for i, numWeapons in bp.Weapon do
            if(bp.Weapon[i].Label == 'WalkerArrival') then
                DamageArea(self, self:GetPosition(), bp.Weapon[i].DamageRadius, bp.Weapon[i].Damage, bp.Weapon[i].DamageType, bp.Weapon[i].DamageFriendly)
                break
            end
        end		
		end)	
    end,
	
	
	
	CreateEnhancement = function(self, enh)
        AWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        #Resource Allocation
        if enh == 'ResourceAllocation' then
            local bp = self:GetBlueprint().Enhancements[enh]
            local bpEcon = self:GetBlueprint().Economy
            if not bp then return end
            self:SetProductionPerSecondEnergy(bp.ProductionPerSecondEnergy + bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bp.ProductionPerSecondMass + bpEcon.ProductionPerSecondMass or 0)
        elseif enh == 'ResourceAllocationRemove' then
            local bpEcon = self:GetBlueprint().Economy
            self:SetProductionPerSecondEnergy(bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bpEcon.ProductionPerSecondMass or 0)
        elseif enh == 'ResourceAllocationAdvanced' then
            local bp = self:GetBlueprint().Enhancements[enh]
            local bpEcon = self:GetBlueprint().Economy
            if not bp then return end
            self:SetProductionPerSecondEnergy(bp.ProductionPerSecondEnergy + bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bp.ProductionPerSecondMass + bpEcon.ProductionPerSecondMass or 0)
        elseif enh == 'ResourceAllocationAdvancedRemove' then
            local bpEcon = self:GetBlueprint().Economy
            self:SetProductionPerSecondEnergy(bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bpEcon.ProductionPerSecondMass or 0)
        #Shields
        elseif enh == 'Shield' then
		    self:AddToggleCap('RULEUTC_ShieldToggle')
			self:EnableShield()	
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:CreatePersonalShield(bp)
        elseif enh == 'ShieldRemove' then
		    self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self:DestroyShield()
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
        elseif enh == 'ShieldHeavy' then
            self:AddToggleCap('RULEUTC_ShieldToggle')
            self:ForkThread(self.CreateHeavyShield, bp)
        elseif enh == 'ShieldHeavyRemove' then
			self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self:DestroyShield()
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
        #Teleporter
        elseif enh == 'Teleporter' then
            self:AddCommandCap('RULEUCC_Teleport')
        elseif enh == 'TeleporterRemove' then
            self:RemoveCommandCap('RULEUCC_Teleport')
        #Chrono Dampener
        elseif enh == 'ChronoDampener' then
            self:SetWeaponEnabledByLabel('ChronoDampener', true)
        elseif enh == 'ChronoDampenerRemove' then
            self:SetWeaponEnabledByLabel('ChronoDampener', false)
        #T2 Engineering
        elseif enh =='AdvancedEngineering' then
            local bp = self:GetBlueprint().Enhancements[enh]
            if not bp then return end
            local cat = ParseEntityCategory(bp.BuildableCategoryAdds)
            self:RemoveBuildRestriction(cat)
            if not Buffs['AeonACUT2BuildRate'] then
                BuffBlueprint {
                    Name = 'AeonACUT2BuildRate',
                    DisplayName = 'AeonACUT2BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'AeonACUT2BuildRate')
        elseif enh =='AdvancedEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if not bp then return end
            self:RestoreBuildRestrictions()
            self:AddBuildRestriction( categories.AEON * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER) )
            if Buff.HasBuff( self, 'AeonACUT2BuildRate' ) then
                Buff.RemoveBuff( self, 'AeonACUT2BuildRate' )
            end
        #T3 Engineering
        elseif enh =='T3Engineering' then
            local bp = self:GetBlueprint().Enhancements[enh]
            if not bp then return end
            local cat = ParseEntityCategory(bp.BuildableCategoryAdds)
            self:RemoveBuildRestriction(cat)
            if not Buffs['AeonACUT3BuildRate'] then
                BuffBlueprint {
                    Name = 'AeonACUT3BuildRate',
                    DisplayName = 'AeonCUT3BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'AeonACUT3BuildRate')
        elseif enh =='T3EngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if not bp then return end
            self:RestoreBuildRestrictions()
            self:AddBuildRestriction( categories.AEON * ( categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER) )
            if Buff.HasBuff( self, 'AeonACUT3BuildRate' ) then
                Buff.RemoveBuff( self, 'AeonACUT3BuildRate' )
            end
        #Crysalis Beam
        elseif enh == 'CrysalisBeam' then
            local wep = self:GetWeaponByLabel('RightDisruptor')
            wep:ChangeMaxRadius(bp.NewMaxRadius or 44)
            local oc = self:GetWeaponByLabel('OverCharge')
            oc:ChangeMaxRadius(bp.NewMaxRadius or 44)
        elseif enh == 'CrysalisBeamRemove' then
            local wep = self:GetWeaponByLabel('RightDisruptor')
            local bpDisrupt = self:GetBlueprint().Weapon[1].MaxRadius
            wep:ChangeMaxRadius(bpDisrupt or 22)
            local oc = self:GetWeaponByLabel('OverCharge')
            oc:ChangeMaxRadius(bpDisrupt or 22)
        #Heat Sink Augmentation
        elseif enh == 'HeatSink' then
            local wep = self:GetWeaponByLabel('RightDisruptor')
            wep:ChangeRateOfFire(bp.NewRateOfFire or 2)
        elseif enh == 'HeatSinkRemove' then
            local wep = self:GetWeaponByLabel('RightDisruptor')
            local bpDisrupt = self:GetBlueprint().Weapon[1].RateOfFire
            wep:ChangeRateOfFire(bpDisrupt or 1)
        #Enhanced Sensor Systems
        elseif enh == 'EnhancedSensors' then
            self:SetIntelRadius('Vision', bp.NewVisionRadius or 104)
            self:SetIntelRadius('Omni', bp.NewOmniRadius or 104)
        elseif enh == 'EnhancedSensorsRemove' then
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
        end
    end,

    CreateHeavyShield = function(self, bp)
        WaitTicks(1)
        self:CreatePersonalShield(bp)
        self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
        self:SetMaintenanceConsumptionActive()
    end,
}

TypeClass = CSKAL0401