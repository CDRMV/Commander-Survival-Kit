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

local StructureUnit = import('/lua/defaultunits.lua').StructureUnit
local DefaultProjectileWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon
local ModEffectpath = '/mods/Commander Survival Kit Units/effects/emitters/'
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local Buff = import('/lua/sim/Buff.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')

URFSSP05XX = Class(StructureUnit) {
    Weapons = {
        Nanites = Class(DefaultProjectileWeapon) {},
    },
	
	RegenBuffThread = function(self)
        while not self:IsDead() do
            #Get friendly units in the area (including self)
            local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE, 
			self:GetPosition(), 
			self:GetBlueprint().Intel.VisionRadius
			
			)
            
            #Give them a 5 second regen buff
            for _,unit in units do
                Buff.ApplyBuff(unit, 'VeterancyRegen5')
            end
            
            #Wait 5 seconds
            WaitSeconds(5)
        end
    end,
	
	HealthBuffThread = function(self)
        while not self:IsDead() do
            #Get friendly units in the area (including self)
            local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE, 
			self:GetPosition(), 
			self:GetBlueprint().Intel.VisionRadius
			
			)
            
            #Give them a 5 second regen buff
            for _,unit in units do
				local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

				if version < 3652 then
					Buff.ApplyBuff(unit, 'VeterancyHealth5')
				else
					Buff.ApplyBuff(unit, 'VeterancyMaxHealth5')
				end
            end
            
            #Wait 5 seconds
            WaitSeconds(5)
        end
    end,
	
    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
		self:ForkThread(
            function()
                self.AimingNode = CreateRotator(self, 0, 'x', 0, 10000, 10000, 1000)
                WaitFor(self.AimingNode)
				local interval = 0
                while (interval < 11) do
				LOG(interval)
					if interval == 10 then 
					    self:GetWeaponByLabel('Nanites'):FireWeapon()
						self:Destroy()
						self.RegenThreadHandle = self:ForkThread(self.HealthBuffThread)
						break
					else
						local num = Ceil((R()+R()+R()+R()+R()+R()+R()+R()+R()+R()+R())*R(1,10))
						coroutine.yield(num)
						self:GetWeaponByLabel('Nanites'):FireWeapon()
						self.RegenThreadHandle = self:ForkThread(self.RegenBuffThread)
						interval = interval + 1
					end
                end
            end
        )
    end,

}

TypeClass = URFSSP05XX