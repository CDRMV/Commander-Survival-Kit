#****************************************************************************
#** 
#**  Author(s):  CDRMV 
#** 
#**  Summary  :  UEF Bunker Script 
#** 
#**  Copyright © 2023 Commander Survival Kit.  All rights reserved.
#****************************************************************************
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

UEBTB0102 = Class(StructureUnit) {		 

    Weapons = {
        Riotgun01 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		Riotgun02 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		Riotgun03 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		Riotgun04 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		Riotgun05 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		Riotgun06 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		Riotgun07 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		Riotgun08 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
    },
	

    OnCreate = function(self)
        StructureUnit.OnCreate(self)
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_Stop')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:RemoveCommandCap('RULEUCC_Transport')
		self:SetWeaponEnabledByLabel('Riotgun01', false)
		self:SetWeaponEnabledByLabel('Riotgun02', false)
		self:SetWeaponEnabledByLabel('Riotgun03', false)
		self:SetWeaponEnabledByLabel('Riotgun04', false)
		self:SetWeaponEnabledByLabel('Riotgun05', false)
		self:SetWeaponEnabledByLabel('Riotgun06', false)
		self:SetWeaponEnabledByLabel('Riotgun07', false)
		self:SetWeaponEnabledByLabel('Riotgun08', false)
    end,
	
	OnStopBeingBuilt = function(self)
        StructureUnit.OnStopBeingBuilt(self)
		self.OpenAnimManip = CreateAnimator(self)
        self.Trash:Add(self.OpenAnimManip)
        self.OpenAnimManip:PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorOpen.sca', false):SetRate(1)
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_Stop')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:RemoveCommandCap('RULEUCC_Transport')
		self:SetWeaponEnabledByLabel('Riotgun01', false)
		self:SetWeaponEnabledByLabel('Riotgun02', false)
		self:SetWeaponEnabledByLabel('Riotgun03', false)
		self:SetWeaponEnabledByLabel('Riotgun04', false)
		self:SetWeaponEnabledByLabel('Riotgun05', false)
		self:SetWeaponEnabledByLabel('Riotgun06', false)
		self:SetWeaponEnabledByLabel('Riotgun07', false)
		self:SetWeaponEnabledByLabel('Riotgun08', false)
    end,
	
	OnScriptBitSet = function(self, bit)
        StructureUnit.OnScriptBitSet(self, bit)
		local location = self:GetPosition()
		if bit == 1 then 
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
				local units = self:GetAIBrain():GetUnitsAroundPoint(categories.TECH1, self:GetPosition(), 8, 'Ally') 
				for _, v in units do
				local CheckUnit = v:GetGuardedUnit()
				if EntityCategoryContains(categories.ENGINEER, v) == true then
				
				elseif EntityCategoryContains(categories.AMPHIBIOUSTRANSPORT, v) == true then
				
				else
				if not v.Dead and v:GetGuardedUnit()then
				if EntityCategoryContains(categories.BUNKER, CheckUnit) == true then
				v:AttachBoneTo(0, self, 0)
				v:HideBone(0,true)
				v:SetUnSelectable(true)
				end
				end
				end
				end
		end)
		self:AddCommandCap('RULEUCC_Attack')
		self:AddCommandCap('RULEUCC_Stop')	
		self:AddCommandCap('RULEUCC_RetaliateToggle')
		self:SetWeaponEnabledByLabel('Riotgun01', true)
		self:SetWeaponEnabledByLabel('Riotgun02', true)
		self:SetWeaponEnabledByLabel('Riotgun03', true)
		self:SetWeaponEnabledByLabel('Riotgun04', true)
		self:SetWeaponEnabledByLabel('Riotgun05', true)
		self:SetWeaponEnabledByLabel('Riotgun06', true)
		self:SetWeaponEnabledByLabel('Riotgun07', true)
		self:SetWeaponEnabledByLabel('Riotgun08', true)
		self.OpenAnimManip:SetRate(-1)
		end	
		if bit == 2 then 
		self.OpenAnimManip:SetRate(1)
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
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_Stop')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:SetWeaponEnabledByLabel('Riotgun01', false)
		self:SetWeaponEnabledByLabel('Riotgun02', false)
		self:SetWeaponEnabledByLabel('Riotgun03', false)
		self:SetWeaponEnabledByLabel('Riotgun04', false)
		self:SetWeaponEnabledByLabel('Riotgun05', false)
		self:SetWeaponEnabledByLabel('Riotgun06', false)
		self:SetWeaponEnabledByLabel('Riotgun07', false)
		self:SetWeaponEnabledByLabel('Riotgun08', false)	
		end
    end,
	
	OnScriptBitClear = function(self, bit)
        StructureUnit.OnScriptBitSet(self, bit)
		local location = self:GetPosition()
		if bit == 1 then 
		self.OpenAnimManip:SetRate(1)
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
				local units = self:GetAIBrain():GetUnitsAroundPoint(categories.TECH1, self:GetPosition(), 8, 'Ally') 
				for _, v in units do
				local CheckUnit = v:GetGuardedUnit()
				if EntityCategoryContains(categories.ENGINEER, v) == true then
				
				elseif EntityCategoryContains(categories.AMPHIBIOUSTRANSPORT, v) == true then
				
				else
				if not v.Dead and v:GetGuardedUnit()then
				if EntityCategoryContains(categories.BUNKER, CheckUnit) == true then
				v:AttachBoneTo(0, self, 0)
				v:HideBone(0,true)
				v:SetUnSelectable(true)
				end
				end
				end
				end
		end)
		self.OpenAnimManip:SetRate(-1)
		end	
		if bit == 2 then 
		self.OpenAnimManip:SetRate(1)
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
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_Stop')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:SetWeaponEnabledByLabel('Riotgun01', false)
		self:SetWeaponEnabledByLabel('Riotgun02', false)
		self:SetWeaponEnabledByLabel('Riotgun03', false)
		self:SetWeaponEnabledByLabel('Riotgun04', false)
		self:SetWeaponEnabledByLabel('Riotgun05', false)
		self:SetWeaponEnabledByLabel('Riotgun06', false)
		self:SetWeaponEnabledByLabel('Riotgun07', false)
		self:SetWeaponEnabledByLabel('Riotgun08', false)	
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


TypeClass = UEBTB0102

