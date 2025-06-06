#****************************************************************************
#**
#**  UEF Medium Artillery Strike
#**  Author(s):  CDRMV
#**
#**  Summary  :  A Dummy Unit which fires Artillery Strikes below it. 
#**				 It is Selectable and Untargetable by enemy Units.				
#**				 It attacks enemy Units automatically in Range and will be destroyed after 10 Seconds.
#**              
#**  Copyright � 2022 Fire Support Manager by CDRMV
#****************************************************************************

local StructureUnit = import('/lua/defaultunits.lua').StructureUnit
local DefaultProjectileWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon
local Modpath = '/mods/Commander Survival Kit/effects/emitters/'
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local Buff = import('/lua/sim/Buff.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')

URFSSP0400b = Class(StructureUnit) {
    OnCreate = function(self)
        StructureUnit.OnCreate(self)
			self:ForkThread(function() 
			self:HideBone('UEFSSP0100b', true)
			while true do
			WaitSeconds(5)
			if not self.Dead then		
			self:CaptureThread()
			end
			end	
			end)	
    end,

    CaptureThread = function(self)
			local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.CSKProjectModName == "CSK-Units" then return mod.location end end end
			local CSKUnitsPath = GetCSKUnitsPath()
            local units = nil
			if CSKUnitsPath then 	
			units = GetArmyBrain(self:GetArmy()):GetUnitsAroundPoint(
			
			categories.ALLUNITS + categories.LAND - categories.EXPERIMENTAL - categories.ELITE - categories.HERO - categories.TITAN,
			self:GetPosition(), 
			10,
			'Enemy'
			
			)
			
			else
			units = GetArmyBrain(self:GetArmy()):GetUnitsAroundPoint(
			
			categories.ALLUNITS + categories.LAND - categories.EXPERIMENTAL,
			self:GetPosition(), 
			10,
			'Enemy'
			
			)
			end
			
			if units[1] == nil then
			WaitSeconds(5)
			self:Destroy()
			else
			ChangeUnitArmy(units[1], self:GetArmy())	
			end
    end,

}

TypeClass = URFSSP0400b