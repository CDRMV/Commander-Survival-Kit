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

local AAirUnit = import('/lua/defaultunits.lua').AirUnit
local TIFMediumArtilleryStrike = import('/mods/Commander Survival Kit/lua/FireSupportBarrages.lua').TIFMediumArtilleryStrike
local AAMSaintWeapon = import('/lua/aeonweapons.lua').AAMSaintWeapon
local nukeFiredOnGotTarget = false

UAFSM0302 = Class(AAirUnit) {

    Weapons = {
        Turret01 = Class(AAMSaintWeapon) {},
		Turret02 = Class(AAMSaintWeapon) {},
    },
    OnCreate = function(self)
        AAirUnit.OnCreate(self)
		local wep1 = self:GetWeaponByLabel("Turret01")
		local wep2 = self:GetWeaponByLabel("Turret02")
		wep2:SetEnabled(false)
        self:ForkThread(function()
		local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )
		if version < 3652 then
		
		else
		wep1:SetEnabled(false)
		wep2:SetEnabled(true)
		end
            WaitSeconds(5) 		
			self:Destroy()			
        end)
    end,
}

TypeClass = UAFSM0302