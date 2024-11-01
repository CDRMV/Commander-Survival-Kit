#****************************************************************************
#**
#**  File     :  /units/XSL0202/XSL0202_script.lua
#**
#**  Summary  :  Seraphim Heavy Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local Effects = '/mods/Commander Survival Kit/effects/emitters/seraphim_chromatic_beam_generator_beam03_emit.bp'
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'
local utilities = import('/lua/utilities.lua')
local Buff = import('/lua/sim/Buff.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local SmallDimensional = '/mods/Commander Survival Kit/effects/Entities/SuperSmallDimensional/SuperSmallDimensional_proj.bp'
local AIFCommanderDeathWeapon = nil
local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then
	AIFCommanderDeathWeapon = import('/lua/aeonweapons.lua').AIFCommanderDeathWeapon
	else 	
	AIFCommanderDeathWeapon = import("/lua/sim/defaultweapons.lua").SCUDeathWeapon
end 

XSB8802 = Class(SWalkingLandUnit) {
	decal = nil, 
	
    ShieldEffects = {
        '/effects/emitters/seraphim_shield_generator_t2_01_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t3_03_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t2_03_emit.bp',
    },

	Weapons = {
        DeathWeapon = Class(AIFCommanderDeathWeapon) {},
    },
	
	OnLayerChange = function(self, new, old)
        SWalkingLandUnit.OnLayerChange(self, new, old)
            if (new == 'Land') and (old != 'None') then
				self:AddToggleCap('RULEUTC_WeaponToggle')
            elseif (new == 'Seabed') then
				self:RemoveToggleCap('RULEUTC_WeaponToggle')
            end
    end,
	
	
	OnMotionHorzEventChange = function(self, new, old)
	SWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
	ForkThread( function()
		if old == 'Stopped' then
			if self:GetScriptBit(1) == true then
				self:SetScriptBit('RULEUTC_WeaponToggle', false)
			end
        elseif new == 'Stopped' then

        end
	end)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        SWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:ForkThread(function()
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationArrival, false):SetRate(0)	
		local army = self:GetArmy()
        local position = self:GetPosition()
		local orientation = RandomFloat(0,2*math.pi)
		self.ArmSlider1 = CreateSlider(self, 'Body')
        self.Trash:Add(self.ArmSlider1)
		self.ArmSlider1:SetGoal(0, 1000, 0)
		self.ArmSlider1:SetSpeed(1000)
		self:HideBone('Body', true) 
		self:HideBone( 'Armor', true )
        self:SetUnSelectable(true)	
		WaitSeconds(5)			
		self.ArmSlider1 = CreateSlider(self, 'Body')
		self.Trash:Add(self.ArmSlider1)        
		self.ArmSlider1:SetGoal(0, -1000, 0)
		self.ArmSlider1:SetSpeed(500)
		self:ShowBone('Body', true) 
		self.ArrivalEffect1 = CreateAttachedEmitter(self,'Body',self:GetArmy(), '/effects/emitters/nuke_munition_launch_trail_05_emit.bp'):ScaleEmitter(4):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1):SetEmitterParam('REPEATTIME', -1)
		self.ArrivalEffect2 = CreateAttachedEmitter(self,'Body',self:GetArmy(), '/effects/emitters/nuke_munition_launch_trail_02_emit.bp'):ScaleEmitter(4):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1):SetEmitterParam('REPEATTIME', -1)
		self:HideBone( 'Armor', true )
		self:HideBone( 'Dimensional', true )
		self:HideBone( 'Shield_Spinner', true)  
		self.number = 0
		self.DimensionalExplosion = false
		self.ArmorUpgrade = false
		self.ShieldEffectsBag = {}
		self.OpenAnimManip = CreateAnimator(self)
        self.Trash:Add(self.OpenAnimManip)
        self.OpenAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(0)
		WaitSeconds(2)
		CreateEmitterOnEntity(self,self:GetArmy(), '/effects/emitters/destruction_explosion_flash_04_emit.bp')
		CreateEmitterOnEntity(self,self:GetArmy(), '/effects/emitters/destruction_explosion_flash_05_emit.bp')
        DamageArea(self, position, 4, 10, 'Force', false, false)
        DamageArea(self, position, 4, 10, 'Fire', false, false)
        CreateDecal(position, orientation, 'Scorch_010_albedo', '', 'Albedo', 12, 12, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 12, 12, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 12, 12, 500, 600, army)
		self.ArrivalEffect1:Destroy()
		self.ArrivalEffect2:Destroy()
		if self.AnimationManipulator then
            self:ForkThread(function()
				self.AnimationManipulator:SetRate(2)
                WaitSeconds(1)
                self.AnimationManipulator:Destroy()
				self:SetUnSelectable(false)	
            end)
        end		
        # Scorch decal and light some trees on fire
        DamageRing(self, position, 20, 27, 1, 'Fire', false, false)
		local bp = self:GetBlueprint()
        for i, numWeapons in bp.Weapon do
            if(bp.Weapon[i].Label == 'WalkerArrival') then
                DamageArea(self, self:GetPosition(), bp.Weapon[i].DamageRadius, bp.Weapon[i].Damage, bp.Weapon[i].DamageType, bp.Weapon[i].DamageFriendly)
                break
            end
        end		
		self.RotatorManipulator = CreateRotator( self, 'B01', 'y' )
		self.RotatorManipulator:SetAccel( 5 )
        self.RotatorManipulator:SetTargetSpeed( 30 )
		if self:GetAIBrain().BrainType != 'Human' then
		else
        end
        self:RequestRefreshUI()
		self.UnitComplete = true
		end)
    end,

	OnScriptBitSet = function(self, bit)
        SWalkingLandUnit.OnScriptBitSet(self, bit)
		local id = self:GetEntityId()
        if bit == 1 then 
			ForkThread( function()
			self:SetUnSelectable(true)
			self:SetImmobile(true)
			self:RemoveCommandCap('RULEUCC_Move')
			self:RemoveCommandCap('RULEUCC_Guard')
			self:RemoveCommandCap('RULEUCC_Patrol')
			self.OpenAnimManip:SetRate(1)
			WaitFor(self.OpenAnimManip)
			self:SetUnSelectable(false)
			end)
        end
		if bit == 2 then 
			self.DimensonalExplosionThreadHandle = self:ForkThread(self.DimensonalExplosionThread)
		end
		if bit == 4 then 
		if self.DimensionalExplosion == true then
			ForkThread( function()
			local Pos = self:GetPosition()
			self:ShowBone('Dimensional_Effect', true)
			self.Effect1 = CreateAttachedEmitter(self,'Dimensional_Effect',self:GetArmy(), ModeffectPath .. 'Dimensional_01_emit.bp'):ScaleEmitter(0.02)
			self.Effect2 = CreateAttachedEmitter(self,'Dimensional_Effect',self:GetArmy(), ModeffectPath .. 'Dimensional_03_emit.bp'):ScaleEmitter(0.02)
			self.Effect3 = CreateAttachedEmitter(self,'Dimensional_Effect',self:GetArmy(), ModeffectPath .. 'Dimensional_04_emit.bp'):ScaleEmitter(0.02)
			self.Effect4 = CreateAttachedEmitter(self,'Dimensional_Effect',self:GetArmy(), ModeffectPath .. 'Dimensional_05_emit.bp'):ScaleEmitter(0.02)
			self.Effect5 = CreateAttachedEmitter(self,'Dimensional_Effect',self:GetArmy(), ModeffectPath .. 'Dimensional_08_emit.bp'):ScaleEmitter(0.02)
			WaitSeconds(5)
			DamageArea(self, Pos, 25, 500, 'Normal', false, false)
			self.Effect1:Destroy()
			self.Effect2:Destroy()
			self.Effect3:Destroy()
			self.Effect4:Destroy()
			self.Effect5:Destroy()
			self:CreateProjectileAtBone( SmallDimensional, 'Dimensional_Effect')
			self:Kill()
			end)
		else
			self:Kill()
        end
		end
		if bit == 7 then 
			self.number = self.number + 1
			if self.number == 1 then
				self.RotatorManipulator:SetTargetSpeed( 0 )
				self:HideBone('Ammo', false)
				self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				ForkThread( function()
				WaitSeconds(20)
				self:ShowBone('Ammo', false)
				self:AddToggleCap('RULEUTC_SpecialToggle')
				self.RotatorManipulator:SetTargetSpeed( 30 )
				end)
			end
			if self.number == 2 then
				self.RotatorManipulator:SetTargetSpeed( 0 )
				self:HideBone('Ammo', false)
				self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				ForkThread( function()
				WaitSeconds(20)
				self:ShowBone('Ammo', false)
				self:AddToggleCap('RULEUTC_SpecialToggle')
				self.RotatorManipulator:SetTargetSpeed( 30 )
				end)
			end
			if self.number == 3 then
				self.RotatorManipulator:SetTargetSpeed( 0 )
				self:HideBone('Ammo', false)
				self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				ForkThread( function()
				WaitSeconds(20)
				self:ShowBone('Ammo', false)
				self:AddToggleCap('RULEUTC_SpecialToggle')
				self.RotatorManipulator:SetTargetSpeed( 30 )
				end)
			end
			if self.number == 4 then
				self.RotatorManipulator:SetTargetSpeed( 0 )
				self:HideBone('Ammo', false)
				self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				FloatingEntityText(id, 'Warning no more boosts available')
				self:AddToggleCap('RULEUTC_ProductionToggle')
			end
        end
		--[[
		if bit == 7 then 
		self.RepairThreadHandle = self:ForkThread(self.RepairThread)
        end
		]]--
    end,

    OnScriptBitClear = function(self, bit)
        SWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
			ForkThread( function()
			self:SetUnSelectable(true)
			self.OpenAnimManip:SetRate(-1)
			WaitFor(self.OpenAnimManip)
			self:AddCommandCap('RULEUCC_Move')
			self:AddCommandCap('RULEUCC_Guard')
			self:AddCommandCap('RULEUCC_Patrol')
			self:SetImmobile(false)
			self:SetUnSelectable(false)
			end)
        end
		if bit == 2 then 
		if self.DimensonalExplosionThreadHandle then
            KillThread(self.DimensonalExplosionThreadHandle)
            self.DimensonalExplosionThreadHandle = nil
        end
		end
		if bit == 7 then 
		self:SetScriptBit('RULEUTC_SpecialToggle', true)
        end
		--[[
		if bit == 7 then 
		KillThread(self.RepairThreadHandle)
        end
		]]--
    end,
	
	WeaponBuffThread = function(self)
			
            #Get friendly units in the area (including self)
            local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.LAND + categories.MOBILE - categories.DROPSUPPLYDEVICE,
			self:GetPosition(), 
			10
			
			)
            if units == nil then
			FloatingEntityText(id, 'No ally Units in near to give them a boost')
			else
            for _,unit in units do
			    if not Buffs['WeaponBuff'] then
                BuffBlueprint {
                    Name = 'WeaponBuff',
                    DisplayName = 'WeaponBuff',
                    BuffType = 'AMMOWEAPONBUFF',
                    Stacks = 'REPLACE',
                    Duration = 20,
                    Affects = {
						MaxRadius = {
						    Add = 10,
                            Mult = 1,
						},
						Damage = {
                            Add =  50,
                            Mult = 1,
                        },
                    },
                }
				end
                Buff.ApplyBuff(unit, 'WeaponBuff')
            end
			end
    end,
	
	RegenBuffThread = function(self)
        while not self:IsDead() do
            #Get friendly units in the area (including self)
            local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE, 
			self:GetPosition(), 
			20
			
			)
            local buff
            local type
			buff = 'MoralRegen1'
			if not Buffs[buff] then
                local buff_bp = {
                    Name = buff,
                    DisplayName = buff,
                    BuffType = 'VETERANCYREGEN',
                    Stacks = 'REPLACE',
                    Duration = 1,
                    Affects = {
                        Regen = {
                            Add = 5,
                            Mult = 1,
                        },
                    },
                }
                BuffBlueprint(buff_bp)
            end
            for _,unit in units do
                Buff.ApplyBuff(unit, 'MoralRegen1')
            end
            
            WaitSeconds(1)
        end
    end,
	
	OnShieldEnabled = function(self)
        SWalkingLandUnit.OnShieldEnabled(self)
        KillThread( self.DestroyManipulatorsThread )
        if not self.RotatorManipulator2 then
            self.RotatorManipulator2 = CreateRotator( self, 'Shield_Spinner', 'y' )
            self.Trash:Add( self.RotatorManipulator2 )
        end
        self.RotatorManipulator2:SetAccel( 5 )
        self.RotatorManipulator2:SetTargetSpeed( 30 )
        
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 'Shield_Spinner', self:GetArmy(), v ):ScaleEmitter(0.15):OffsetEmitter(0, -0.73, 0) )
        end
    end,

    OnShieldDisabled = function(self)
        SWalkingLandUnit.OnShieldDisabled(self)
        KillThread( self.DestroyManipulatorsThread )
        self.DestroyManipulatorsThread = self:ForkThread( self.DestroyManipulators )
        self.RotatorManipulator2:SetTargetSpeed( 0 )
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
    end,
	
	CreateEnhancement = function(self, enh)
        SWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
		if enh =='Armor' then
		if self:GetScriptBit(1) == true then
		self:ShowBone('Armor', false)
		self:HideBone( 'R_Leg_B01', true )
		self:HideBone( 'L_Leg_B01', true )
		self:HideBone( 'Leg_B01', true )
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self.ArmorUpgrade = true
		else
		ForkThread( function()
		self:SetScriptBit('RULEUTC_WeaponToggle', true)
		WaitSeconds(1)
		self:ShowBone('Armor', false)
		self:HideBone( 'R_Leg_B01', true )
		self:HideBone( 'L_Leg_B01', true )
		self:HideBone( 'Leg_B01', true )
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self.ArmorUpgrade = true
		end)
		end
        elseif enh =='ArmorRemove' then
		ForkThread( function()
		self:HideBone('Armor', false)
		self:ShowBone( 'R_Leg_B01', true )
		self:ShowBone( 'L_Leg_B01', true )
		self:ShowBone( 'Leg_B01', true )
		self:SetMaxHealth(5000)
		self:SetHealth(self, 5000)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:SetScriptBit('RULEUTC_WeaponToggle', false)
		self.ArmorUpgrade = false
		end)
		elseif enh =='MovableMode' then
		ForkThread( function()
		self:HideBone('Armor', false)
		self:ShowBone( 'R_Leg_B01', true )
		self:ShowBone( 'L_Leg_B01', true )
		self:ShowBone( 'Leg_B01', true )
		self:SetMaxHealth(5000)
		self:SetHealth(self, 5000)
		end)
        elseif enh =='MovableModeRemove' then
		--self:AddToggleCap('RULEUTC_WeaponToggle')
		--self:SetScriptBit('RULEUTC_WeaponToggle', false)
		elseif enh =='Shield' then
		self:AddToggleCap('RULEUTC_ShieldToggle')
		self:ShowBone('Shield_Spinner', true)
		self:CreateShield(bp)
        self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
		self:SetMaintenanceConsumptionActive()
        self:AddToggleCap('RULEUTC_ShieldToggle')
        elseif enh =='ShieldRemove' then
		if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
		self:HideBone('Shield_Spinner', true)
		self:DestroyShield()
		self:SetMaintenanceConsumptionInactive()
        self:RemoveToggleCap('RULEUTC_ShieldToggle')
		elseif enh =='DimensionalShockwave' then
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self:HideBone('Ring1', true)
		self:HideBone('Ammo', true)
		self:ShowBone('Dimensional', false)
		self.ImpulseWaveThreadHandle = self:ForkThread(self.ImpulseWaveThread)
        elseif enh =='DimensionalShockwaveRemove' then
		if self.ImpulseWaveThreadHandle then
            KillThread(self.ImpulseWaveThreadHandle)
            self.ImpulseWaveThreadHandle = nil
        end
		self:HideBone('Dimensional', true)
		self:ShowBone('Ring1', true)
		elseif enh =='DimensionalExplosion' then
		self.DimensionalExplosion = true
		self:SetScriptBit('RULEUTC_WeaponToggle', true)
		if self.ImpulseWaveThreadHandle then
            KillThread(self.ImpulseWaveThreadHandle)
            self.ImpulseWaveThreadHandle = nil
        end
		self:AddToggleCap('RULEUTC_ProductionToggle')
		self:AddToggleCap('RULEUTC_JammingToggle')
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self:HideBone('Ring1', true)
		self:HideBone('Ammo', true)
		self:ShowBone('Dimensional', false)
        elseif enh =='DimensionalExplosionRemove' then
		self.DimensionalExplosion = false
		self:HideBone('Dimensional', true)
		self:ShowBone('Ring1', true)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:RemoveToggleCap('RULEUTC_ProductionToggle')
		self:RemoveToggleCap('RULEUTC_JammingToggle')
		elseif enh =='Regen' then
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self:HideBone('Ring1', true)
		self:HideBone('Ring2', true)
		self:HideBone('Ammo', true)
		self.RegenAura = CreateAttachedEmitter( self, 0, self:GetArmy(), '/effects/emitters/seraphim_regenerative_aura_01_emit.bp' ):OffsetEmitter(0, -0.76, 0)
		self.RegenAura1 = CreateAttachedEmitter( self, 'RegenAura', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_01_emit.bp' ):ScaleEmitter(0.5)
		self.RegenAura2 = CreateAttachedEmitter( self, 'RegenAura', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp' ):ScaleEmitter(0.5)
		self.RegenAura3 = CreateAttachedEmitter( self, 'RegenAura', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp' ):ScaleEmitter(0.5)
		self.RegenAura4 = CreateAttachedEmitter( self, 'RegenAura', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp' ):ScaleEmitter(0.5)
		self.RegenAura5 = CreateAttachedEmitter( self, 'RegenAura', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_05_emit.bp' ):ScaleEmitter(0.5)
		self.RegenBuffThreadHandle = self:ForkThread(self.RegenBuffThread)
        elseif enh =='RegenRemove' then
		self:ShowBone('Ring1', true)
		self:ShowBone('Ring2', true)
		if self.RegenAura then
		self.RegenAura:Destroy()
		end
		if self.RegenAura1 then
		self.RegenAura1:Destroy()
		end
		if self.RegenAura2 then
		self.RegenAura2:Destroy()
		end
		if self.RegenAura3 then
		self.RegenAura3:Destroy()
		end
		if self.RegenAura4 then
		self.RegenAura4:Destroy()
		end
		if self.RegenAura5 then
		self.RegenAura5:Destroy()
		end
		if self.RegenBuffThreadHandle then
            KillThread(self.RegenBuffThreadHandle)
            self.RegenBuffThreadHandle = nil
        end
		end
    end,
	
	ImpulseWaveThread = function(self)
		local Pos = self:GetPosition()
		local number = 0
		while true do
        while not self:IsDead() do
            local landunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.ALLUNITS - categories.AIR, 
			self:GetPosition(), 
			25,
			'Enemy'
			
			)
			
		if landunits[1]	== nil then
		
		else
		if number == 0 then
		if self.ArmorUpgrade == false then
		self:SetScriptBit('RULEUTC_WeaponToggle', true)
		
		else
		
		end
		WaitSeconds(1)
		self:ShowBone('Dimensional_Effect', true)
		self.Effect1 = CreateAttachedEmitter(self,'Dimensional_Effect',self:GetArmy(), ModeffectPath .. 'Dimensional_01_emit.bp'):ScaleEmitter(0.02)
		self.Effect2 = CreateAttachedEmitter(self,'Dimensional_Effect',self:GetArmy(), ModeffectPath .. 'Dimensional_03_emit.bp'):ScaleEmitter(0.02)
		self.Effect3 = CreateAttachedEmitter(self,'Dimensional_Effect',self:GetArmy(), ModeffectPath .. 'Dimensional_04_emit.bp'):ScaleEmitter(0.02)
		self.Effect4 = CreateAttachedEmitter(self,'Dimensional_Effect',self:GetArmy(), ModeffectPath .. 'Dimensional_05_emit.bp'):ScaleEmitter(0.02)
		self.Effect5 = CreateAttachedEmitter(self,'Dimensional_Effect',self:GetArmy(), ModeffectPath .. 'Dimensional_08_emit.bp'):ScaleEmitter(0.02)
		number = number + 1
		end
		
		
		WaitSeconds(5)
		self:HideBone('Dimensional_Effect', true)
		CreateAttachedEmitter(self, 'Dimensional_Effect', self:GetArmy(), '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp'):ScaleEmitter(0.65)
		DamageArea(self, Pos, 25, 500, 'Normal', false, false)
		self.Effect1:Destroy()
		self.Effect2:Destroy()
		self.Effect3:Destroy()
		self.Effect4:Destroy()
		self.Effect5:Destroy()
		number = 0
		WaitSeconds(2)
        end
		WaitSeconds(1)
		end
		WaitSeconds(1)
		end
    end,
	
	DimensonalExplosionThread = function(self)
		local Pos = self:GetPosition()
		local number = 0
		while true do
        while not self:IsDead() do
            local landunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.ALLUNITS - categories.AIR, 
			self:GetPosition(), 
			25,
			'Enemy'
			
			)
			
		if landunits[1]	== nil then
		
		else
		if number == 0 then
		self:ShowBone('Dimensional_Effect', true)
		self.Effect1 = CreateAttachedEmitter(self,'Dimensional_Effect',self:GetArmy(), ModeffectPath .. 'Dimensional_01_emit.bp'):ScaleEmitter(0.02)
		self.Effect2 = CreateAttachedEmitter(self,'Dimensional_Effect',self:GetArmy(), ModeffectPath .. 'Dimensional_03_emit.bp'):ScaleEmitter(0.02)
		self.Effect3 = CreateAttachedEmitter(self,'Dimensional_Effect',self:GetArmy(), ModeffectPath .. 'Dimensional_04_emit.bp'):ScaleEmitter(0.02)
		self.Effect4 = CreateAttachedEmitter(self,'Dimensional_Effect',self:GetArmy(), ModeffectPath .. 'Dimensional_05_emit.bp'):ScaleEmitter(0.02)
		self.Effect5 = CreateAttachedEmitter(self,'Dimensional_Effect',self:GetArmy(), ModeffectPath .. 'Dimensional_08_emit.bp'):ScaleEmitter(0.02)
		WaitSeconds(5)
		DamageArea(self, Pos, 25, 500, 'Normal', false, false)
		self.Effect1:Destroy()
		self.Effect2:Destroy()
		self.Effect3:Destroy()
		self.Effect4:Destroy()
		self.Effect5:Destroy()
		self:CreateProjectileAtBone( SmallDimensional, 'Dimensional_Effect')
		self:Kill()
        end
		end
		WaitSeconds(1)
		end
		WaitSeconds(1)
		end
    end,

	
	DeathThread = function( self, overkillRatio, instigator)

        #LOG('*DEBUG: OVERKILL RATIO = ', repr(overkillRatio))

        WaitSeconds( utilities.GetRandomFloat( self.DestructionExplosionWaitDelayMin, self.DestructionExplosionWaitDelayMax) )
        self:DestroyAllDamageEffects()

		if self.RegenAura then
		self.RegenAura:Destroy()
		end
		
		if self.RegenAura1 then
		self.RegenAura1:Destroy()
		end
		if self.RegenAura2 then
		self.RegenAura2:Destroy()
		end
		if self.RegenAura3 then
		self.RegenAura3:Destroy()
		end
		if self.RegenAura4 then
		self.RegenAura4:Destroy()
		end
		if self.RegenAura5 then
		self.RegenAura5:Destroy()
		end

        if self.PlayDestructionEffects then
            self:CreateDestructionEffects( self, overkillRatio )
        end

        #MetaImpact( self, self:GetPosition(), 0.1, 0.5 )
		if self:GetScriptBit(1) == false then
        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
            if self.PlayDestructionEffects and self.PlayEndAnimDestructionEffects then
                self:CreateDestructionEffects( self, overkillRatio )
            end
		end	
		else
		    if self.PlayDestructionEffects and self.PlayEndAnimDestructionEffects then
                self:CreateDestructionEffects( self, overkillRatio )
            end
        end

        self:CreateWreckage( overkillRatio )

        # CURRENTLY DISABLED UNTIL DESTRUCTION
        # Create destruction debris out of the mesh, currently these projectiles look like crap,
        # since projectile rotation and terrain collision doesn't work that great. These are left in
        # hopes that this will look better in the future.. =)
        if( self.ShowUnitDestructionDebris and overkillRatio ) then
            if overkillRatio <= 1 then
                self.CreateUnitDestructionDebris( self, true, true, false )
            elseif overkillRatio <= 2 then
                self.CreateUnitDestructionDebris( self, true, true, false )
            elseif overkillRatio <= 3 then
                self.CreateUnitDestructionDebris( self, true, true, true )
            else #VAPORIZED
                self.CreateUnitDestructionDebris( self, true, true, true )
            end
        end

        #LOG('*DEBUG: DeathThread Destroying in ',  self.DeathThreadDestructionWaitTime )
        WaitSeconds(self.DeathThreadDestructionWaitTime)

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,

}
TypeClass = XSB8802