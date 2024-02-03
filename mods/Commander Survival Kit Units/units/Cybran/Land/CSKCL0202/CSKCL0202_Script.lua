#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0202/URL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local CWeapons = import('/lua/cybranweapons.lua')
local CDFLaserDisintegratorWeapon = CWeapons.CDFLaserDisintegratorWeapon02

CSKCL0202 = Class(CLandUnit) {

    Weapons = {
        Disintegrator = Class(CDFLaserDisintegratorWeapon) {
            OnCreate = function(self)
                CDFLaserDisintegratorWeapon.OnCreate(self)
                #Disable buff 
                self:DisableBuff('STUN')
            end,
        },
    },

    OnStopBeingBuilt = function(self,builder,layer)
        CLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.OpenAnimManip = CreateAnimator(self)
        self.Trash:Add(self.OpenAnimManip)
        self.OpenAnimManip:PlayAnim('/mods/Commander Survival Kit Units/units/Cybran/Land/CSKCL0202/CSKCL0202_RollPack.sca', false):SetRate(0)		
    end,

	OnMotionHorzEventChange = function(self, new, old)
        CLandUnit.OnMotionHorzEventChange(self, new, old)

        if old == 'Stopped' then
			self:SetScriptBit('RULEUTC_ShieldToggle', false)
			self:RemoveToggleCap('RULEUTC_ShieldToggle')
        elseif new == 'Stopped' then
			self:AddToggleCap('RULEUTC_ShieldToggle')
			self:SetScriptBit('RULEUTC_ShieldToggle', true)
        end
    end,
}

TypeClass = CSKCL0202