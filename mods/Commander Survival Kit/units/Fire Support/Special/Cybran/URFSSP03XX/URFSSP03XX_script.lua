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
local ModEffectpath = '/mods/Commander Survival Kit/effects/emitters/'
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local Buff = import('/lua/sim/Buff.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')

URFSSP01XX = Class(StructureUnit) {
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
            local buff
            local type
			buff = 'NaniteRegen1'
			if not Buffs[buff] then
                local buff_bp = {
                    Name = buff,
                    DisplayName = buff,
                    BuffType = 'VETERANCYREGEN',
                    Stacks = 'REPLACE',
                    Duration = 1,
                    Affects = {
                        Regen = {
                            Add = 5,
                            Mult = 1,
                        },
                    },
                }
                BuffBlueprint(buff_bp)
            end
            for _,unit in units do
                Buff.ApplyBuff(unit, 'NaniteRegen1')
            end
            
            WaitSeconds(1)
        end
    end,
	
	StunThread = function(self)
        while not self:IsDead() do
            #Get friendly units in the area (including self)
			DamageArea(self, self:GetPosition(), self:GetBlueprint().Intel.VisionRadius, 10, 'Fire', false, false)
            local units = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE, 
			self:GetPosition(), 
			self:GetBlueprint().Intel.VisionRadius,
			'Enemy'
			
			)
            #Give them a 5 second regen buff
            for _,unit in units do
				unit:SetStunned(2)
            end
            
            #Wait 5 seconds
            WaitSeconds(5)
        end
    end,
	
	
	
    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
			self:ForkThread(function()
				self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'nanites_01_emit.bp'):ScaleEmitter(0.9):SetEmitterParam('LIFETIME', -1)
				self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'nanites_03_emit.bp'):ScaleEmitter(0.9):SetEmitterParam('LIFETIME', -1)
				local interval = 0
                while (interval < 11) do
				LOG(interval)
					if interval < 10 then 
						self.RegenThreadHandle = self:ForkThread(self.RegenBuffThread)
						self.StunThreadHandle = self:ForkThread(self.StunThread)
						WaitSeconds(1)
						interval = interval + 1
					elseif interval == 10 then
						self.Effect1:Destroy()
						self.Effect2:Destroy()
						self:Destroy()
						break
					end
                end		
			end)
    end,

}

TypeClass = URFSSP01XX