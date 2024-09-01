#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0303/URL0303_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local cWeapons = import('/lua/cybranweapons.lua')
local CDFLaserDisintegratorWeapon = cWeapons.CDFLaserDisintegratorWeapon01
local number = 0

CSKCL0305 = Class(CWalkingLandUnit) 
{

    Weapons = {
		Gun1 = Class(CDFLaserDisintegratorWeapon) {
		
			
		OnWeaponFired = function(self)
			if number == 0 then
			self.Rotator = CreateRotator(self.unit, 'Turret', 'y', nil, 0, 60, 80)
			self.unit.Trash:Add(self.Rotator)
			number = number + 1	
			elseif number == 2 then
			
			else
			number = number + 1	
			end
		end,
			
            
        OnLostTarget = function(self)
			if self.Rotator == nil then
			else
		  	self.Rotator:SetTargetSpeed(0)
			self.Rotator:SetGoal(0)
			number = 0
			end
        end,
            
		},
    },
	
	DeathThread = function( self, overkillRatio , instigator)  

        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end

    
        self:DestroyAllDamageEffects()
        self:CreateWreckage( overkillRatio )
		
		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end
		
		self:HideBone('Turret', true)
        # Spawn an engineer (temp energy being)
        local position = self:GetPosition()
        local Nanites = CreateUnitHPR('URFSSP03XX', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
	
	CreateWreckage = function (self, overkillRatio)
		self:HideBone('Turret', true)
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
	

}

TypeClass = CSKCL0305