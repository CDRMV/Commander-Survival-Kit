#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0203/UAA0203_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Gunship Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/defaultunits.lua').AirUnit
local ADFLaserLightWeapon = import('/lua/aeonweapons.lua').ADFLaserLightWeapon
local ADFCannonOblivionWeapon = import('/lua/aeonweapons.lua').ADFCannonOblivionWeapon
local ADFPhasonLaser = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').ADFMiniPhasonLaser

CSKAA0302 = Class(AAirUnit) {
    Weapons = {
		OblivionTurret = Class(ADFCannonOblivionWeapon) {},
        Turret = Class(ADFLaserLightWeapon) {
			FxChassisMuzzleFlash = {'/effects/emitters/aeon_gunship_body_illumination_01_emit.bp',},
			
			PlayFxMuzzleSequence = function(self, muzzle)
				local bp = self:GetBlueprint()
				local army = self.unit:GetArmy()
				for k, v in self.FxMuzzleFlash do
					CreateAttachedEmitter(self.unit, muzzle, army, v)
				end
				
				for k, v in self.FxChassisMuzzleFlash do
					CreateAttachedEmitter(self.unit, -1, army, v)
				end
				
				if self.unit:GetCurrentLayer() == 'Water' and bp.Audio.FireUnderWater then
					self:PlaySound(bp.Audio.FireUnderWater)
				elseif bp.Audio.Fire then
					self:PlaySound(bp.Audio.Fire)
				end
			end,        
        },
		BeamWeapon = Class(ADFPhasonLaser) {},
    },
	
	OnKilled = function(self, instigator, type, overkillRatio)
        AAirUnit.OnKilled(self, instigator, type, overkillRatio)
        local wep = self:GetWeaponByLabel('BeamWeapon')
        local bp = wep:GetBlueprint()
        if bp.Audio.BeamStop then
            wep:PlaySound(bp.Audio.BeamStop)
        end
        if bp.Audio.BeamLoop and wep.Beams[1].Beam then
            wep.Beams[1].Beam:SetAmbientSound(nil, nil)
        end
        for k, v in wep.Beams do
            v.Beam:Disable()
        end     
    end,
}

TypeClass = CSKAA0302