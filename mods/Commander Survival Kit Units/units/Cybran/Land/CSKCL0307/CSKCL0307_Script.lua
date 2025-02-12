#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0303/URL0303_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )
local CWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local explosion = import('/lua/defaultexplosions.lua')
local CMobileAdvancedKamikazeBombWeapon = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').CMobileAdvancedKamikazeBombWeapon
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local Weapon = import('/lua/sim/Weapon.lua').Weapon


CSKCL0307 = Class(CWalkingLandUnit) 
{

    Weapons = {
        
        Suicide = Class(CMobileAdvancedKamikazeBombWeapon) {   
     
			OnFire = function(self)			
				self.unit:Kill()
				CMobileAdvancedKamikazeBombWeapon.OnFire(self)
			end,
        },
    },
	
	OnMotionHorzEventChange = function(self, new, old)
        CWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
		if old == 'Stopped' then
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
        elseif new == 'Stopped' then
			self:AddToggleCap('RULEUTC_WeaponToggle')
			self:SetScriptBit('RULEUTC_WeaponToggle', false)
        end
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		self.OpenAnimManip = CreateAnimator(self)
        self.Trash:Add(self.OpenAnimManip)
        self.OpenAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(0)
        self.Spinner1 = CreateRotator(self, 'Drill', 'x', nil, 0, 60, 360):SetTargetSpeed(0),
        self.Trash:Add(self.Spinner1)

        self:SetMaintenanceConsumptionInactive()
        self:SetScriptBit('RULEUTC_CloakToggle', true)
		if self:GetAIBrain().BrainType != 'Human' then
			LOG('AI: ADS activated') -- Activate the Automatic Detonation System for AI Support
            self:SetScriptBit('RULEUTC_SpecialToggle', true)
		else
			LOG('Human Player: ADS deactivated') -- Deactivate the Automatic Detonation System for Human Players
			self:SetScriptBit('RULEUTC_SpecialToggle', false)
        end
		self:RemoveToggleCap('RULEUTC_CloakToggle')
        self:RequestRefreshUI()
		self.UnitComplete = true
    end,
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
			self:SetScriptBit('RULEUTC_SpecialToggle', false)
			self:RemoveToggleCap('RULEUTC_SpecialToggle')
			ForkThread( function()
            self.Spinner1:SetTargetSpeed(180)
			self.Effect1 = CreateAttachedEmitter(self,'Drill',self:GetArmy(), '/effects/emitters/dust_cloud_05_emit.bp'):ScaleEmitter(1):SetEmitterParam('LIFETIME', 20)
			self.Trash:Add(self.Effect1)
			self:SetUnSelectable(true)
			self:SetImmobile(true)
			self:RemoveCommandCap('RULEUCC_Move')
			self:RemoveCommandCap('RULEUCC_Guard')
			self:RemoveCommandCap('RULEUCC_Patrol')
			self.OpenAnimManip:SetRate(1)
			WaitFor(self.OpenAnimManip)
			CreateDecal(self:GetPosition(), 0, 'scorch_001_albedo', '', 'Albedo', 2, 2, 150, 150, self:GetArmy())
			self:SetMaintenanceConsumptionActive()
			self:AddToggleCap('RULEUTC_CloakToggle')
			self:SetScriptBit('RULEUTC_CloakToggle', false)
			self:SetUnSelectable(false)
			self.MineCheckTargetsThreadHandle = self:ForkThread(self.MineCheckTargetsThread)
			self.Spinner1:SetTargetSpeed(0)
			end)
        end
		if bit == 7 then 
			self.AutomaticDetonationThreadHandle = self:ForkThread(self.AutomaticDetonationThread)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
			ForkThread( function()
			CreateDecal(self:GetPosition(), 0, 'scorch_001_albedo', '', 'Albedo', 2, 2, 150, 150, self:GetArmy())
			self.Effect1 = CreateAttachedEmitter(self,'Drill',self:GetArmy(), '/effects/emitters/dust_cloud_05_emit.bp'):ScaleEmitter(1):SetEmitterParam('LIFETIME', 20)
			self.Trash:Add(self.Effect1)
            self.Spinner1:SetTargetSpeed(180)
			self:SetUnSelectable(true)
		    self:SetMaintenanceConsumptionInactive()
			self:SetScriptBit('RULEUTC_CloakToggle', true)
			self:RemoveToggleCap('RULEUTC_CloakToggle')
			self.OpenAnimManip:SetRate(-1)
			WaitFor(self.OpenAnimManip)
			self:AddCommandCap('RULEUCC_Move')
			self:AddCommandCap('RULEUCC_Guard')
			self:AddCommandCap('RULEUCC_Patrol')
			self:SetImmobile(false)
			self:SetUnSelectable(false)
            self.Spinner1:SetTargetSpeed(0)
			self:SetScriptBit('RULEUTC_SpecialToggle', true)
			self:AddToggleCap('RULEUTC_SpecialToggle')
			end)
        end
		if bit == 7 then 
			KillThread(self.AutomaticDetonationThreadHandle)
        end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
        self:DestroyAllDamageEffects()
		local army = self:GetArmy()

		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end
		
		CreateAttachedEmitter(self, 'CSKCL0307', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'CSKCL0307', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'CSKCL0307', 1.0)
		explosion.CreateFlash( self, 'CSKCL0307', 2.5, army )
		local FxDeath = EffectTemplate.CMobileKamikazeBombExplosion
		for k, v in FxDeath do
            CreateEmitterAtBone(self,-2,army,v)
        end  
		local position = self:GetPosition()
		local rotation = 6.28 * Random()
        DamageArea(self, position, 6, 1, 'TreeForce', true)
        DamageArea(self, position, 6, 1, 'TreeForce', true)
        CreateDecal(position, rotation, 'scorch_010_albedo', '', 'Albedo', 11, 11, 250, 120, army)
		self:CreateWreckage(overkillRatio or self.overkillRatio)
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		local Nanites = CreateUnitHPR('URFSSP10XX', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
	
	CreateWreckage = function (self, overkillRatio)
		self:HideBone('CSKCL0307', true)
        if overkillRatio and overkillRatio > 1.0 then
            return
        end
        local bp = self.Blueprint
        local fractionComplete = self:GetFractionComplete()
        if fractionComplete < 0.5 or ((bp.TechCategory == 'EXPERIMENTAL' or bp.CategoriesHash["STRUCTURE"]) and fractionComplete < 1) then
            return
        end
        return self:CreateWreckageProp(overkillRatio)
    end,

	MineCheckTargetsThread = function(self)
		LOG('MineCheckTargetsThread')
		local unitPos = self:GetPosition()
        while not self:IsDead() do
            #Get Enemy units in the area
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, 4, 'Enemy')
            for _,unit in units do
				ForkThread( function()
				self.ArmSlider = CreateSlider(self, 'Trigger')
				self.Trash:Add(self.ArmSlider)
				self.ArmSlider:SetGoal(0, 0, -4)
				self.ArmSlider:SetSpeed(80)
				WaitFor(self.ArmSlider)
				self:GetWeaponByLabel'Suicide':FireWeapon()
				self:Kill()
				end)
            end
            
            #Wait 3 seconds
            WaitSeconds(3)
        end
    end,
	
	AutomaticDetonationThread = function(self)
 		while not self:IsDead() do
			local unitPos = self:GetPosition()
            #Get Enemy units in the area
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, 4, 'Enemy')
            for _,unit in units do
				ForkThread( function()
				self.ArmSlider = CreateSlider(self, 'Trigger')
				self.Trash:Add(self.ArmSlider)
				self.ArmSlider:SetGoal(0, 0, -4)
				self.ArmSlider:SetSpeed(80)
				WaitFor(self.ArmSlider)
				self:GetWeaponByLabel'Suicide':FireWeapon()
				self:Kill()
				end)
            end
            
            #Wait 2 seconds
            WaitSeconds(2)
		end	
    end,

	
}
TypeClass = CSKCL0307