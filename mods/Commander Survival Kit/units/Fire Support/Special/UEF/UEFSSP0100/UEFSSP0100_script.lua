#****************************************************************************
#**
#**  UEF Medium Artillery Strike
#**  Author(s):  CDRMV
#**
#**  Summary  :  A Dummy Unit which fires Artillery Strikes below it. 
#**				 It is Selectable and Untargetable by enemy Units.				
#**				 It attacks enemy Units automatically in Range and will be destroyed after 10 Seconds.
#**              
#**  Copyright © 2022 Fire Support Manager by CDRMV
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TIFMediumArtilleryStrike = import('/mods/Commander Survival Kit/lua/FireSupportBarrages.lua').TIFMediumArtilleryStrike

UEFSSP0100 = Class(TAirUnit) {

    Weapons = {
        Turret01 = Class(TIFMediumArtilleryStrike) {
		OnWeaponFired = function(self)
		self.unit:Destroy()
		end,
		},
    },
	
	SmokeScreenThread = function(self)
		while not self:IsDead() do
            local units = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.MOBILE - categories.AIR, 
			self:GetPosition(), 
			self:GetBlueprint().Intel.VisionRadius,
			'Ally'
			
			)
			
			if units[1] ~= nil then
			local TargetPosition = units[1]:GetPosition()
			self:GetWeaponByLabel'Turret01':SetTargetGround(TargetPosition)
			WaitSeconds(1)
			self:GetWeaponByLabel'Turret01':FireWeapon()			
			end
            
            WaitSeconds(0.1)
        end
    end,
	
    OnCreate = function(self)
        TAirUnit.OnCreate(self)
        self:ForkThread(function()
		local interval = 0
                while (interval < 21) do
				LOG(interval)
					if interval < 20 then 
						self.SmokeScreenThreadHandle = self:ForkThread(self.SmokeScreenThread)
						WaitSeconds(1)
						interval = interval + 1
					elseif interval == 20 then
						self:Destroy()
						break
					end
                end		
        end)
    end,
}

TypeClass = UEFSSP0100