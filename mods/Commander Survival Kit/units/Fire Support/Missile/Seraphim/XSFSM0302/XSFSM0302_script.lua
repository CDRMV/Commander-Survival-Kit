#****************************************************************************
#**
#**  UEF Medium Artillery Strike
#**  Author(s):  CDRMV
#**
#**  Summary  :  A Dummy Unit which fires Artillery Strikes below it. 
#**				 It is Selectable and Untargetable by enemy Units.				
#**				 It attacks enemy Units automatically in Range and will be destroyed after 5 Seconds.
#**              
#**  Copyright © 2022 Fire Support Manager by CDRMV
#****************************************************************************

local SAirUnit = import('/lua/defaultunits.lua').AirUnit
local TIFMediumArtilleryStrike = import('/mods/Commander Survival Kit/lua/FireSupportBarrages.lua').TIFMediumArtilleryStrike
local SIFHuAntiNukeWeapon = import('/lua/seraphimweapons.lua').SIFHuAntiNukeWeapon
local nukeFiredOnGotTarget = false

XSFSM0302 = Class(SAirUnit) {

    Weapons = {
        Turret01 = Class(TAMInterceptorWeapon) {},
		Turret02 = Class(TAMInterceptorWeapon) {},
    },
    OnCreate = function(self)
        TAirUnit.OnCreate(self)
		local wep1 = self:GetWeaponByLabel("Turret01")
		wep1:SetEnabled(false)
		local wep2 = self:GetWeaponByLabel("Turret02")
		wep2:SetEnabled(false)
        self:ForkThread(function()
		local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )
		if version < 3652 then
		wep1:SetEnabled(true)
		else
		wep2:SetEnabled(true)
		end
            WaitSeconds(5) 		-- Time Windwo to select the Unit and order it to fire on the Ground
			self:Destroy()			-- Unit will be destroyed 
        end)
    end,
}

TypeClass = XSFSM0302