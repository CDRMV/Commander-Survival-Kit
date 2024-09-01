#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0202/URL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/defaultunits.lua').RollingLandUnit
local CIFGrenadeWeapon = import('/lua/cybranweapons.lua').CIFGrenadeWeapon
local explosion = import('/lua/defaultexplosions.lua')

CSKCL0306 = Class(CLandUnit) {

    Weapons = {
        MissileRack = Class(CIFGrenadeWeapon) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        CLandUnit.OnStopBeingBuilt(self,builder,layer)
        self.Spinners = {
            Spinner1 = CreateRotator(self, 'L_Rad_Spinner', 'y', nil, 0, 60, 360):SetTargetSpeed(0),
            Spinner2 = CreateRotator(self, 'R_Rad_Spinner', 'y', nil, 0, 60, 360):SetTargetSpeed(0),
        }
        for k, v in self.Spinners do
            self.Trash:Add(v)
        end

    end,


	OnMotionHorzEventChange = function(self, new, old)
        CLandUnit.OnMotionHorzEventChange(self, new, old)
		ForkThread( function()
		if old == 'Stopped' then
            self.Spinners.Spinner1:SetTargetSpeed(-90)
            self.Spinners.Spinner2:SetTargetSpeed(90)
        elseif new == 'Stopped' then
            self.Spinners.Spinner1:SetTargetSpeed(0)
            self.Spinners.Spinner2:SetTargetSpeed(0)
        end
		end)
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  

		explosion.CreateDefaultHitExplosionAtBone( self, 'CSKCL0306', 5.0 ) 
		self:HideBone('CSKCL0306', true)
		self:ShowBone('L_Rad', true)
		self:ShowBone('R_Rad', true)

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

		--[[
        local position = self:GetPosition()
        local Nanites = CreateUnitHPR('URFSSP03XX', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		]]--
		
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
	
	CreateWreckage = function (self, overkillRatio)
		self:HideBone('CSKCL0306', true)
		self:ShowBone('L_Rad', true)
		self:ShowBone('R_Rad', true)
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

TypeClass = CSKCL0306