#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2301/UEB2301_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

UEBTB0302 = Class(TStructureUnit) {
    Weapons = {

    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
						self.EggSlider = CreateSlider(self, 'Hammer')
		self.Trash:Add(self.EggSlider)
				self.EggSlider = CreateSlider(self, 'Hammer')
		self.Trash:Add(self.EggSlider)
		ForkThread( function()
        while true do
            if not self.EggSlider then return end
            self.EggSlider:SetGoal(0, 60, 0)
            self.EggSlider:SetSpeed(40)
            WaitFor(self.EggSlider)
            self.EggSlider:SetGoal(0, 0, 0)
            WaitFor(self.EggSlider)
			self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), '/effects/emitters/dust_cloud_05_emit.bp'):ScaleEmitter(2):SetEmitterParam('LIFETIME', 30)
			self.Trash:Add(self.Effect1)
			self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), '/effects/emitters/dust_cloud_06_emit.bp'):ScaleEmitter(5):SetEmitterParam('LIFETIME', 30):OffsetEmitter(0,-1,0)
			--self:ShakeCamera(200, 1, 0, 20)
			local rotation = RandomFloat(0,2*math.pi)
			local size = RandomFloat(15.75,15.0)
			CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 10, self:GetArmy())
			local bp = self:GetBlueprint()
        for i, numWeapons in bp.Weapon do
            if(bp.Weapon[i].Label == 'AntiUnderGround') then
                DamageArea(self, self:GetPosition(), bp.Weapon[i].DamageRadius, bp.Weapon[i].Damage, bp.Weapon[i].DamageType, bp.Weapon[i].DamageFriendly)
                break
            end
			if(bp.Weapon[i].Label == 'Surface') then
                DamageArea(self, self:GetPosition(), bp.Weapon[i].DamageRadius, bp.Weapon[i].Damage, bp.Weapon[i].DamageType, bp.Weapon[i].DamageFriendly)
                break
            end
        end	
		end
		end)
    end,
	
	
	OnScriptBitSet = function(self, bit)
        TStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 

		end
    end,
	
	OnScriptBitClear = function(self, bit)
        TStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 

		end
    end,
}

TypeClass = UEBTB0302