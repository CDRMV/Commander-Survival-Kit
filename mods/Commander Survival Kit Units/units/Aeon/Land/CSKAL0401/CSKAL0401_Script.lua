#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0303/UAL0303_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Siege Assault Bot Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local ADFLaserHighIntensityWeapon = import('/lua/aeonweapons.lua').ADFLaserHighIntensityWeapon
local ADFCannonQuantumWeapon = import('/lua/aeonweapons.lua').ADFCannonQuantumWeapon
local AAAZealotMissileWeapon = import('/lua/aeonweapons.lua').AAAZealotMissileWeapon
local AAMWillOWisp = import('/lua/aeonweapons.lua').AAMWillOWisp
local CSKUWeaponFile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua')
local ADFGreenLaserBeamWeapon = CSKUWeaponFile.ADFGreenLaserBeamWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local EffectTemplate = import('/lua/EffectTemplates.lua')

CSKAL0401 = Class(AWalkingLandUnit) {   
	decal = nil, 
    Weapons = {
        FrontTurret01 = Class(ADFLaserHighIntensityWeapon) {},
        AntiMissile = Class(AAMWillOWisp) {},
		MissileLauncher = Class(AAAZealotMissileWeapon) {},
		TorsoMissileLauncher = Class(AAAZealotMissileWeapon) {},
		TorsoAntiMissile = Class(AAMWillOWisp) {},
		Leg1LaserTurret = Class(ADFLaserHighIntensityWeapon) {},
		Leg1QuantumTurret = Class(ADFCannonQuantumWeapon) {},
		Leg1AAMissileLauncher = Class(AAAZealotMissileWeapon) {},
		Leg1MissileLauncher = Class(AAAZealotMissileWeapon) {},
		Leg1BeamTurret = Class(ADFGreenLaserBeamWeapon) {},
		Leg2LaserTurret = Class(ADFLaserHighIntensityWeapon) {},
		Leg2QuantumTurret = Class(ADFCannonQuantumWeapon) {},
		Leg2AAMissileLauncher = Class(AAAZealotMissileWeapon) {},
		Leg2MissileLauncher = Class(AAAZealotMissileWeapon) {},
		Leg2BeamTurret = Class(ADFGreenLaserBeamWeapon) {},
		Leg3LaserTurret = Class(ADFLaserHighIntensityWeapon) {},
		Leg3QuantumTurret = Class(ADFCannonQuantumWeapon) {},
		Leg3AAMissileLauncher = Class(AAAZealotMissileWeapon) {},
		Leg3MissileLauncher = Class(AAAZealotMissileWeapon) {},
		Leg3BeamTurret = Class(ADFGreenLaserBeamWeapon) {},
		Leg4LaserTurret = Class(ADFLaserHighIntensityWeapon) {},
		Leg4QuantumTurret = Class(ADFCannonQuantumWeapon) {},
		Leg4AAMissileLauncher = Class(AAAZealotMissileWeapon) {},
		Leg4MissileLauncher = Class(AAAZealotMissileWeapon) {},
		Leg4BeamTurret = Class(ADFGreenLaserBeamWeapon) {},
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
		self:SetWeaponEnabledByLabel('FrontTurret01', false)
		self:SetWeaponEnabledByLabel('MissileLauncher', false)
		self:SetWeaponEnabledByLabel('AntiMissile', false)
		self:SetWeaponEnabledByLabel('Leg1MissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg2MissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg3MissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg4MissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg1AAMissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg2AAMissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg3AAMissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg4AAMissileLauncher', false)
		self:SetWeaponEnabledByLabel('TorsoMissileLauncher', false)
		self:SetWeaponEnabledByLabel('TorsoAntiMissile', false)
		self:SetWeaponEnabledByLabel('Leg1LaserTurret', false)
		self:SetWeaponEnabledByLabel('Leg2LaserTurret', false)
		self:SetWeaponEnabledByLabel('Leg3LaserTurret', false)
		self:SetWeaponEnabledByLabel('Leg4LaserTurret', false)
		self:SetWeaponEnabledByLabel('Leg1QuantumTurret', false)
		self:SetWeaponEnabledByLabel('Leg2QuantumTurret', false)
		self:SetWeaponEnabledByLabel('Leg3QuantumTurret', false)
		self:SetWeaponEnabledByLabel('Leg4QuantumTurret', false)
		self:SetWeaponEnabledByLabel('Leg1BeamTurret', false)
		self:SetWeaponEnabledByLabel('Leg2BeamTurret', false)
		self:SetWeaponEnabledByLabel('Leg3BeamTurret', false)
		self:SetWeaponEnabledByLabel('Leg4BeamTurret', false)
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
		self:SetWeaponEnabledByLabel('FrontTurret01', false)
		self:SetWeaponEnabledByLabel('MissileLauncher', false)
		self:SetWeaponEnabledByLabel('AntiMissile', false)
		self:SetWeaponEnabledByLabel('Leg1MissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg2MissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg3MissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg4MissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg1AAMissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg2AAMissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg3AAMissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg4AAMissileLauncher', false)
		self:SetWeaponEnabledByLabel('TorsoMissileLauncher', false)
		self:SetWeaponEnabledByLabel('TorsoAntiMissile', false)
		self:SetWeaponEnabledByLabel('Leg1LaserTurret', false)
		self:SetWeaponEnabledByLabel('Leg2LaserTurret', false)
		self:SetWeaponEnabledByLabel('Leg3LaserTurret', false)
		self:SetWeaponEnabledByLabel('Leg4LaserTurret', false)
		self:SetWeaponEnabledByLabel('Leg1QuantumTurret', false)
		self:SetWeaponEnabledByLabel('Leg2QuantumTurret', false)
		self:SetWeaponEnabledByLabel('Leg3QuantumTurret', false)
		self:SetWeaponEnabledByLabel('Leg4QuantumTurret', false)
		self:SetWeaponEnabledByLabel('Leg1BeamTurret', false)
		self:SetWeaponEnabledByLabel('Leg2BeamTurret', false)
		self:SetWeaponEnabledByLabel('Leg3BeamTurret', false)
		self:SetWeaponEnabledByLabel('Leg4BeamTurret', false)
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
				self:SetWeaponEnabledByLabel('FrontTurret01', true)
				self:SetWeaponEnabledByLabel('MissileLauncher', true)
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
        if enh == 'AllAntiMissile' then
			self:SetWeaponEnabledByLabel('MissileLauncher', false)
			self:SetWeaponEnabledByLabel('AntiMissile', true)
        elseif enh == 'AllAntiMissileRemove' then
			self:SetWeaponEnabledByLabel('MissileLauncher', true)
			self:SetWeaponEnabledByLabel('AntiMissile', false)
        elseif enh == 'AllLegsLaserBlaster' then
			self:SetWeaponEnabledByLabel('Leg1LaserTurret', true)
			self:SetWeaponEnabledByLabel('Leg2LaserTurret', true)
			self:SetWeaponEnabledByLabel('Leg3LaserTurret', true)
			self:SetWeaponEnabledByLabel('Leg4LaserTurret', true)
        elseif enh == 'AllLegsLaserBlasterRemove' then
			self:SetWeaponEnabledByLabel('Leg1LaserTurret', false)
			self:SetWeaponEnabledByLabel('Leg2LaserTurret', false)
			self:SetWeaponEnabledByLabel('Leg3LaserTurret', false)
			self:SetWeaponEnabledByLabel('Leg4LaserTurret', false)
		elseif enh == 'AllLegsQuantumCannon' then
			self:SetWeaponEnabledByLabel('Leg1QuantumTurret', true)
			self:SetWeaponEnabledByLabel('Leg2QuantumTurret', true)
			self:SetWeaponEnabledByLabel('Leg3QuantumTurret', true)
			self:SetWeaponEnabledByLabel('Leg4QuantumTurret', true)
        elseif enh == 'AllLegsQuantumCannonRemove' then
			self:SetWeaponEnabledByLabel('Leg1QuantumTurret', false)
			self:SetWeaponEnabledByLabel('Leg2QuantumTurret', false)
			self:SetWeaponEnabledByLabel('Leg3QuantumTurret', false)
			self:SetWeaponEnabledByLabel('Leg4QuantumTurret', false)
		elseif enh == 'AllLegsBeam' then
			self:SetWeaponEnabledByLabel('Leg1BeamTurret', true)
			self:SetWeaponEnabledByLabel('Leg2BeamTurret', true)
			self:SetWeaponEnabledByLabel('Leg3BeamTurret', true)
			self:SetWeaponEnabledByLabel('Leg4BeamTurret', true)
        elseif enh == 'AllLegsBeamRemove' then
			self:SetWeaponEnabledByLabel('Leg1BeamTurret', false)
			self:SetWeaponEnabledByLabel('Leg2BeamTurret', false)
			self:SetWeaponEnabledByLabel('Leg3BeamTurret', false)
			self:SetWeaponEnabledByLabel('Leg4BeamTurret', false)
		elseif enh == 'AllTorsoMissile' then
			self:SetWeaponEnabledByLabel('TorsoMissileLauncher', true)
        elseif enh == 'AllTorsoMissileRemove' then
			self:SetWeaponEnabledByLabel('TorsoMissileLauncher', false)
		elseif enh == 'AllTorsoAntiMissile' then
			self:SetWeaponEnabledByLabel('TorsoAntiMissile', true)
        elseif enh == 'AllTorsoAntiMissileRemove' then
			self:SetWeaponEnabledByLabel('TorsoAntiMissile', false)
		elseif enh == 'AllLegsMissile' then
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:SetScriptBit('RULEUTC_WeaponToggle', true)

        elseif enh == 'AllLegsMissileRemove' then
		self:SetWeaponEnabledByLabel('Leg1AAMissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg2AAMissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg3AAMissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg4AAMissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg1MissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg2MissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg3MissileLauncher', false)
		self:SetWeaponEnabledByLabel('Leg4MissileLauncher', false)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		
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
		elseif enh == 'Armor' then
		if not Buffs['DeroyArmorPlatingUpgrade1'] then
                BuffBlueprint {
                    Name = 'DeroyArmorPlatingUpgrade1',
                    DisplayName = 'Deroy Armor Plating Imrovement',
                    BuffType = 'DeroyArmorPlatingUpgrade1',
                    Stacks = 'STACKS',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
						Health = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
						Regenerate = {
                            Add = bp.NewRegenerate,
                            Mult = 1.0,
                        },
                    },
                }
            end
		Buff.ApplyBuff(self, 'DeroyArmorPlatingUpgrade1')
        elseif enh == 'ArmorRemove' then
			if Buff.HasBuff(self, 'DeroyArmorPlatingUpgrade1') then
                Buff.RemoveBuff(self, 'DeroyArmorPlatingUpgrade1')
            end
        elseif enh == 'Armor2' then
		if not Buffs['DeroyArmorPlatingUpgrade2'] then
                BuffBlueprint {
                    Name = 'DeroyArmorPlatingUpgrade2',
                    DisplayName = 'Deroy Armor Plating Imrovement',
                    BuffType = 'DeroyArmorPlatingUpgrade2',
                    Stacks = 'STACKS',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
						Health = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
						Regenerate = {
                            Add = bp.NewRegenerate,
                            Mult = 1.0,
                        },
                    },
                }
            end
		Buff.ApplyBuff(self, 'DeroyArmorPlatingUpgrade2')
        elseif enh == 'Armor2Remove' then
		    if Buff.HasBuff(self, 'DeroyArmorPlatingUpgrade2') then
                Buff.RemoveBuff(self, 'DeroyArmorPlatingUpgrade2')
            end
		end
    end,

    CreateHeavyShield = function(self, bp)
        WaitTicks(1)
        self:CreatePersonalShield(bp)
        self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
        self:SetMaintenanceConsumptionActive()
    end,
	
	OnScriptBitSet = function(self, bit)
        AWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
			self:SetWeaponEnabledByLabel('Leg1AAMissileLauncher', true)
			self:SetWeaponEnabledByLabel('Leg2AAMissileLauncher', true)
			self:SetWeaponEnabledByLabel('Leg3AAMissileLauncher', true)
			self:SetWeaponEnabledByLabel('Leg4AAMissileLauncher', true)
			self:SetWeaponEnabledByLabel('Leg1MissileLauncher', false)
			self:SetWeaponEnabledByLabel('Leg2MissileLauncher', false)
			self:SetWeaponEnabledByLabel('Leg3MissileLauncher', false)
			self:SetWeaponEnabledByLabel('Leg4MissileLauncher', false)
        end
    end,

    OnScriptBitClear = function(self, bit)
        AWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		    self:SetWeaponEnabledByLabel('Leg1AAMissileLauncher', false)
			self:SetWeaponEnabledByLabel('Leg2AAMissileLauncher', false)
			self:SetWeaponEnabledByLabel('Leg3AAMissileLauncher', false)
			self:SetWeaponEnabledByLabel('Leg4AAMissileLauncher', false)
			self:SetWeaponEnabledByLabel('Leg1MissileLauncher', true)
			self:SetWeaponEnabledByLabel('Leg2MissileLauncher', true)
			self:SetWeaponEnabledByLabel('Leg3MissileLauncher', true)
			self:SetWeaponEnabledByLabel('Leg4MissileLauncher', true)
        end
    end,
}

TypeClass = CSKAL0401