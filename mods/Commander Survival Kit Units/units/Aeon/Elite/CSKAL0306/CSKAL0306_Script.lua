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
local AeonWeapons = import('/lua/aeonweapons.lua')
local ADFCannonOblivionWeapon = AeonWeapons.ADFPhasonLaser
local SDFUnstablePhasonBeam = import('/lua/seraphimweapons.lua').SDFUnstablePhasonBeam
local EffectUtil = import('/lua/EffectUtilities.lua')
local ADFQuantumBeam = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').ADFQuantumBeam

CSKAL0306 = Class(AWalkingLandUnit) {    
    Weapons = {
        QuantumBeam = Class(ADFQuantumBeam) {},
		LightningWeapon = Class(SDFUnstablePhasonBeam) {}
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
		self.CheckCloseTargetsThreadHandle = self:ForkThread(self.CheckCloseTargetsThread)
        AWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
	    local wep1 = self:GetWeaponByLabel('QuantumBeam')
            local bp1 = wep1:GetBlueprint()
            if bp1.Audio.BeamStop then
                wep1:PlaySound(bp1.Audio.BeamStop)
            end
            if bp1.Audio.BeamLoop and wep1.Beams[1].Beam then
                wep1.Beams[1].Beam:SetAmbientSound(nil, nil)
            end
            for k, v in wep1.Beams do
                v.Beam:Disable()
        end 
		local wep2 = self:GetWeaponByLabel('LightningWeapon')
            local bp2 = wep2:GetBlueprint()
            if bp2.Audio.BeamStop then
                wep2:PlaySound(bp2.Audio.BeamStop)
            end
            if bp2.Audio.BeamLoop and wep2.Beams[1].Beam then
                wep2.Beams[1].Beam:SetAmbientSound(nil, nil)
            end
            for k, v in wep2.Beams do
                v.Beam:Disable()
        end 
        AWalkingLandUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
	
	CheckCloseTargetsThread = function(self)
		--
		-- This Function disables the Quantum Beam if enemy Units are inside the Range of the Lightning Weapon
		-- The Quantum Beam will be enabled if enemy units are not inside the Range of the Lightning Weapon
		-- The Max Range of the Lighning Weapon is 15 but I had to set the Radius of the Check below to 17 to make it functional as it should be.
		--
		local unitPos = self:GetPosition()
        while not self:IsDead() do
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, 17, 'Enemy')
			if units[1] == nil then
			local wep1 = self:GetWeaponByLabel('QuantumBeam')
			wep1:SetEnabled(true)			
			else
			local wep1 = self:GetWeaponByLabel('QuantumBeam')
			local bp1 = wep1:GetBlueprint()
            if bp1.Audio.BeamStop then
                wep1:PlaySound(bp1.Audio.BeamStop)
            end
            if bp1.Audio.BeamLoop and wep1.Beams[1].Beam then
                wep1.Beams[1].Beam:SetAmbientSound(nil, nil)
            end
            for k, v in wep1.Beams do
                v.Beam:Disable()
			end 
			wep1:SetEnabled(false)
			end
            WaitSeconds(0.1)
        end
    end,
}

TypeClass = CSKAL0306