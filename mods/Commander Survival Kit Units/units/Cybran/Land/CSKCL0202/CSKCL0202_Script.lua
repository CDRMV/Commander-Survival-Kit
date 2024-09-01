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
    	self:SetSpeedMult(0.5)
		self:AddCommandCap('RULEUCC_Attack')
		self:AddCommandCap('RULEUCC_RetaliateToggle')
		self:SetWeaponEnabledByLabel('Disintegrator', true)
	end,
	
	OnScriptBitSet = function(self, bit)
        CLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
			self:RemoveCommandCap('RULEUCC_Attack')
			self:RemoveCommandCap('RULEUCC_RetaliateToggle')
			self:SetWeaponEnabledByLabel('Disintegrator', false)
			self.OpenAnimManip:Destroy()
			self.OpenAnimManip = CreateAnimator(self)
			self.Trash:Add(self.OpenAnimManip)
			self.OpenAnimManip:PlayAnim('/mods/Commander Survival Kit Units/units/Cybran/Land/CSKCL0202/CSKCL0202_RollPack.sca', false):SetRate(2)
			self:SetSpeedMult(1.5)
			self:SetScriptBit('RULEUTC_ShieldToggle', false)
			self:RemoveToggleCap('RULEUTC_ShieldToggle')
        end
    end,

    OnScriptBitClear = function(self, bit)
        CLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
			self:SetSpeedMult(0.5)
			self.OpenAnimManip:Destroy()
			self.OpenAnimManip = CreateAnimator(self)
			self.Trash:Add(self.OpenAnimManip)
			self.OpenAnimManip:PlayAnim('/mods/Commander Survival Kit Units/units/Cybran/Land/CSKCL0202/CSKCL0202_RollPack.sca', false):SetRate(0)
			self:AddToggleCap('RULEUTC_ShieldToggle')
			self:SetScriptBit('RULEUTC_ShieldToggle', true)
			self:AddCommandCap('RULEUCC_Attack')
			self:AddCommandCap('RULEUCC_RetaliateToggle')
			self:SetWeaponEnabledByLabel('Disintegrator', true)
        end
    end,

	OnMotionHorzEventChange = function(self, new, old)
        CLandUnit.OnMotionHorzEventChange(self, new, old)
		ForkThread( function()
		if old == 'Stopped' then
			if self:GetScriptBit(1) == true then
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			self.OpenAnimManip:Destroy()
			self.OpenAnimManip = CreateAnimator(self)
			self.Trash:Add(self.OpenAnimManip)
			self.OpenAnimManip:PlayAnim('/mods/Commander Survival Kit Units/units/Cybran/Land/CSKCL0202/CSKCL0202_Walk.sca', true):SetRate(1.5)
			elseif self:GetScriptBit(1) == false then
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			self.OpenAnimManip:Destroy()
			self.OpenAnimManip = CreateAnimator(self)
			self.Trash:Add(self.OpenAnimManip)
			self.OpenAnimManip:PlayAnim('/mods/Commander Survival Kit Units/units/Cybran/Land/CSKCL0202/CSKCL0202_Roll.sca', true):SetRate(4.5)
			end
        elseif new == 'Stopped' then
			if self:GetScriptBit(1) == true then
			self:AddToggleCap('RULEUTC_WeaponToggle')
			self.OpenAnimManip:Destroy()
			self.OpenAnimManip = CreateAnimator(self)
			self.Trash:Add(self.OpenAnimManip)
			self.OpenAnimManip:PlayAnim('/mods/Commander Survival Kit Units/units/Cybran/Land/CSKCL0202/CSKCL0202_RollPack.sca', false):SetRate(0)
			elseif self:GetScriptBit(1) == false then
			self:AddToggleCap('RULEUTC_WeaponToggle')
			self.OpenAnimManip:SetRate(0)
			end
        end
		end)
    end,
}

TypeClass = CSKCL0202