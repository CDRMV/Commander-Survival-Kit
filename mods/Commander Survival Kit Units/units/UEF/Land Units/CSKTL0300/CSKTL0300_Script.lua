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
CSKTL0300 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
        },
    },
	
	DetachBone = 'Launchpoint',
	
	OnStopBeingBuilt = function(self,builder,layer)
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
                self.TerrainLayerTransitionThread = self:ForkThread(self.TransformThread, false)
            elseif (new == 'Water') then
				local cargo = self:GetCargo()
				for k, unit in cargo do
					unit:DestroyMovementEffects()
					unit:CreateMovementEffects(self.MovementEffectsBag, nil)
				end
				self:RemoveToggleCap('RULEUTC_WeaponToggle')
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
		local location = self:GetPosition()
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0300/CSKTL0300_DoorOpen.sca'):SetRate(1)
		LOG('Test')
        if self.Dead then return end 

        local cargo = self:GetCargo()
        for k, unit in cargo do
		LOG('cargo: ', cargo)
        unit:DetachFrom(true)
        self:DetachAll(self.DetachBone)
		unit:ShowBone(0, true)
		local height = GetTerrainHeight(location[1],location[3])
		Warp(unit, {location[1], height, location[3]})		
		local worldPos = self:CalculateWorldPositionFromRelative({0, 0, -10})
		IssueMoveOffFactory({unit}, worldPos)
        end
		Dooropen:SetRate(-1)
		end	
    end,
	
	OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
		if bit == 1 then 
		local location = self:GetPosition()
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0300/CSKTL0300_DoorOpen.sca'):SetRate(1)
		LOG('Test')
        if self.Dead then return end 

        local cargo = self:GetCargo()
        for k, unit in cargo do
		LOG('cargo: ', cargo)
        unit:DetachFrom(true)
        self:DetachAll(self.DetachBone)
		unit:ShowBone(0, true)
		local height = GetTerrainHeight(location[1],location[3])
		Warp(unit, {location[1], height, location[3]})	
		local worldPos = self:CalculateWorldPositionFromRelative({0, 0, -10})
		IssueMoveOffFactory({unit}, worldPos)		
        end
		Dooropen:SetRate(-1)
		end	
    end,
}

TypeClass = CSKTL0300