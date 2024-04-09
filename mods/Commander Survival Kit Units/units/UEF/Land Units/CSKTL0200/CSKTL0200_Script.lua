#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0304/UEL0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Heavy Artillery Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local Modpath = '/mods/Commander Survival Kit Units/effects/emitters/'
local AIUtils = import('/lua/ai/aiutilities.lua')
CSKTL0200 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
        },
    },
	
	OnCreate = function(self)
        TLandUnit.OnCreate(self)
		self:RemoveCommandCap('RULEUCC_Transport')
    end,
	
	OnLayerChange = function(self, new, old)
        TLandUnit.OnLayerChange(self, new, old)
        if self:GetBlueprint().Display.AnimationWater then
            if self.TerrainLayerTransitionThread then
                self.TerrainLayerTransitionThread:Destroy()
                self.TerrainLayerTransitionThread = nil
            end
            if (new == 'Land') and (old != 'None') then
				self:AddToggleCap('RULEUTC_WeaponToggle')
				self:AddToggleCap('RULEUTC_JammingToggle')
                self.TerrainLayerTransitionThread = self:ForkThread(self.TransformThread, false)
            elseif (new == 'Water') then
				local cargo = self:GetCargo()
				for k, unit in cargo do
					unit:DestroyMovementEffects()
					unit:CreateMovementEffects(self.MovementEffectsBag, nil)
				end
				self:RemoveToggleCap('RULEUTC_WeaponToggle')
				self:RemoveToggleCap('RULEUTC_JammingToggle')
                self.TerrainLayerTransitionThread = self:ForkThread(self.TransformThread, true)
            end
        end
    end,

    TransformThread = function(self, water)
        
        if not self.TransformManipulator then
            self.TransformManipulator = CreateAnimator(self)
            self.Trash:Add( self.TransformManipulator )
        end

        if water then
            self.TransformManipulator:PlayAnim(self:GetBlueprint().Display.AnimationWater)
            self.TransformManipulator:SetRate(1)
            self.TransformManipulator:SetPrecedence(0)
        else
            self.TransformManipulator:SetRate(-1)
            self.TransformManipulator:SetPrecedence(0)
            WaitFor(self.TransformManipulator)
            self.TransformManipulator:Destroy()
            self.TransformManipulator = nil
        end
    end,
	
	
	OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
		if bit == 1 then 
		local id = self:GetEntityId()
		local location = self:GetPosition()
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0200/CSKTL0200_DoorOpen.sca'):SetRate(1)
        if self.Dead then return end 

        local cargo = self:GetCargo()
        for k, unit in cargo do
		LOG('cargo: ', cargo)
		unit:DetachFrom(true)
		Warp(unit, location)
		unit:HideBone(0, true)
        end
		ForkThread( function()
		WaitSeconds(1)
		local transports = self:GetAIBrain():GetUnitsAroundPoint(categories.AMPHIBIOUSTRANSPORT, self:GetPosition(), 8, 'Ally')
		local ammountoftransports = table.getn(transports)
		for _, v in transports do
		if ammountoftransports == 1 or ammountoftransports == 0 then	
				local units = self:GetAIBrain():GetUnitsAroundPoint(categories.TECH1, self:GetPosition(), 8, 'Ally') 
				for _, v in units do
				local CheckUnit = v:GetGuardedUnit()
				if EntityCategoryContains(categories.ENGINEER, v) == true then
				
				elseif EntityCategoryContains(categories.AMPHIBIOUSTRANSPORT, v) == true then
				
				else
				if not v.Dead and v:GetGuardedUnit()then
				if EntityCategoryContains(categories.AMPHIBIOUSTRANSPORT, CheckUnit) == true then
				v:AttachBoneTo(0, self, 'Storage')
				v:HideBone(0,true)
				v:SetUnSelectable(true)
				end
				end
				end
				end
		else
		DrawCircle(location, 8, "Red")
		FloatingEntityText(id, 'An another Transport is in the near!')	
		end	
		end
		end)
		Dooropen:SetRate(-1)
		end	
		if bit == 2 then 
		local location = self:GetPosition()
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0200/CSKTL0200_DoorOpen.sca'):SetRate(1)
		LOG('Test')
        if self.Dead then return end 

        local cargo = self:GetCargo()
        for k, unit in cargo do
		LOG('cargo: ', cargo)
		unit:DetachFrom(true)
		unit:ShowBone(0, true)
		unit:SetUnSelectable(false)
		Warp(unit, location)		
        end
		Dooropen:SetRate(-1)
		end
    end,
	
	OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
		if bit == 1 then 
		local id = self:GetEntityId()
		local location = self:GetPosition()
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0200/CSKTL0200_DoorOpen.sca'):SetRate(1)
        if self.Dead then return end 

        local cargo = self:GetCargo()
        for k, unit in cargo do
		LOG('cargo: ', cargo)
		unit:DetachFrom(true)
		Warp(unit, location)
		unit:HideBone(0, true)
        end
		ForkThread( function()
		WaitSeconds(1)
		local transports = self:GetAIBrain():GetUnitsAroundPoint(categories.AMPHIBIOUSTRANSPORT, self:GetPosition(), 8, 'Ally')
		local ammountoftransports = table.getn(transports)
		for _, v in transports do
		if ammountoftransports == 1 or ammountoftransports == 0 then	
				local units = self:GetAIBrain():GetUnitsAroundPoint(categories.TECH1, self:GetPosition(), 8, 'Ally') 
				for _, v in units do
				local CheckUnit = v:GetGuardedUnit()
				if EntityCategoryContains(categories.ENGINEER, v) == true then
				
				elseif EntityCategoryContains(categories.AMPHIBIOUSTRANSPORT, v) == true then
				
				else
				if not v.Dead and v:GetGuardedUnit()then
				if EntityCategoryContains(categories.AMPHIBIOUSTRANSPORT, CheckUnit) == true then
				v:AttachBoneTo(0, self, 'Storage')
				v:HideBone(0,true)
				v:SetUnSelectable(true)
				end
				end
				end
				end
		else
		DrawCircle(location, 8, "Red")
		FloatingEntityText(id, 'An another Transport is in the near!')	
		end	
		end
		end)
		Dooropen:SetRate(-1)
		end	
		if bit == 2 then 
		local location = self:GetPosition()
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0200/CSKTL0200_DoorOpen.sca'):SetRate(1)
		LOG('Test')
        if self.Dead then return end 

        local cargo = self:GetCargo()
        for k, unit in cargo do
		LOG('cargo: ', cargo)
		unit:DetachFrom(true)
		unit:ShowBone(0, true)
		unit:SetUnSelectable(false)
		Warp(unit, location)		
        end
		Dooropen:SetRate(-1)
		end
    end,
	
	
	 OnKilled = function(self, instigator, type, overkillRatio)
	 
	 local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

	if version < 3652 then
	 
	
			local location = self:GetPosition()
		local cargo = self:GetCargo()
		for k, unit in cargo do
		unit:DetachFrom(true)
		unit:ShowBone(0, true)
		unit:SetUnSelectable(false)
		Warp(unit, location)	
		end
	
        
        self.Dead = true
    
        local bp = self:GetBlueprint()
        if self:GetCurrentLayer() == 'Water' and bp.Physics.MotionType == 'RULEUMT_Hover' then
            self:PlayUnitSound('HoverKilledOnWater')
        end
        
        if self:GetCurrentLayer() == 'Land' and bp.Physics.MotionType == 'RULEUMT_AmphibiousFloating' then
            --Handle ships that can walk on land...
            self:PlayUnitSound('AmphibiousFloatingKilledOnLand')
        else
            self:PlayUnitSound('Killed')
        end
        

        #If factory, destory what I'm building if I die
        if EntityCategoryContains(categories.FACTORY, self) then
            if self.UnitBeingBuilt and not self.UnitBeingBuilt:IsDead() and self.UnitBeingBuilt:GetFractionComplete() != 1 then
                self.UnitBeingBuilt:Kill()
            end
        end

        if self.PlayDeathAnimation and not self:IsBeingBuilt() then
            self:ForkThread(self.PlayAnimationThread, 'AnimationDeath')
            self:SetCollisionShape('None')
        end
        --self:OnKilledVO()
        self:DoUnitCallbacks( 'OnKilled' )
        self:DestroyTopSpeedEffects()

        if self.UnitBeingTeleported and not self.UnitBeingTeleported:IsDead() then
            self.UnitBeingTeleported:Destroy()
            self.UnitBeingTeleported = nil
        end

        #Notify instigator that you killed me.
        if instigator and IsUnit(instigator) then
            instigator:OnKilledUnit(self)
        end
        if self.DeathWeaponEnabled != false then
            self:DoDeathWeapon()
        end
        self:DisableShield()
        self:DisableUnitIntel()
        self:ForkThread(self.DeathThread, overkillRatio , instigator)

	else
	
		local location = self:GetPosition()
		local cargo = self:GetCargo()
		for k, unit in cargo do
		unit:DetachFrom(true)
		unit:ShowBone(0, true)
		unit:SetUnSelectable(false)
		Warp(unit, location)	
		end


        if not (self.CanBeKilled) then
            return
        end

        -- this flag is used to skip the need of `IsDestroyed`
        self.Dead = true

        local layer = self.Layer
        local bp = self.Blueprint
        local army = self.Army

        -- Units killed while being invisible because they're teleporting should show when they're killed
        if self.TeleportFx_IsInvisible then
            self:ShowBone(0, true)
            self:ShowEnhancementBones()
        end

        if layer == 'Water' and bp.Physics.MotionType == 'RULEUMT_Hover' then
            self:PlayUnitSound('HoverKilledOnWater')
        elseif layer == 'Land' and bp.Physics.MotionType == 'RULEUMT_AmphibiousFloating' then
            -- Handle ships that can walk on land
            self:PlayUnitSound('AmphibiousFloatingKilledOnLand')
        else
            self:PlayUnitSound('Killed')
        end

        -- apply death animation on half built units (do not apply for ML and mega)
        local FractionThreshold = bp.General.FractionThreshold or 0.5
        if self.PlayDeathAnimation and self:GetFractionComplete() > FractionThreshold then
            self:ForkThread(self.PlayAnimationThread, 'AnimationDeath')
            self.DisallowCollisions = true
        end

        self:DoUnitCallbacks('OnKilled')
        if self.UnitBeingTeleported and not self.UnitBeingTeleported.Dead then
            self.UnitBeingTeleported:Destroy()
            self.UnitBeingTeleported = nil
        end

        if self.DeathWeaponEnabled ~= false then
            self:DoDeathWeapon()
        end

        -- veterancy computations should happen after triggering death weapons
        --VeterancyComponent.VeterancyDispersal(self)

        self:DisableShield()
        self:DisableUnitIntel('Killed')
        self:ForkThread(self.DeathThread, overkillRatio , instigator)

        -- awareness for traitor game mode and game statistics
        ArmyBrains[army].LastUnitKilledBy = (instigator or self).Army
        ArmyBrains[army]:AddUnitStat(self.UnitId, "lost", 1)

        -- awareness of instigator that it killed a unit, but it can also be a projectile or nil
        if instigator and instigator.OnKilledUnit then
            instigator:OnKilledUnit(self)
        end

        self.Brain:OnUnitKilled(self, instigator, type, overkillRatio)
	
	end
	
	end,
	

	
}

TypeClass = CSKTL0200