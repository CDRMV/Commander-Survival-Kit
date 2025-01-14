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

UCRLN0403 = Class(StructureUnit) {
    Weapons = {
        Nanites = Class(DefaultProjectileWeapon) {},
    },
	
    OnStopBeingBuilt = function(self,builder,layer)
					local location = self:GetPosition()
		self:ForkThread(
            function()
				local interval = 0
				        local entity = import('/lua/sim/Entity.lua').Entity()
                while (interval < 31) do
				LOG(interval)
				if interval == 2 then
				entity:SetPosition(Vector(location[1], location[2], location[3]), true)
				entity:SetMesh('/mods/Commander Survival Kit/meshes/Cybran/Megalith_Mesh')
				entity:SetDrawScale(0.057)
				entity:SetVizToAllies'Intel'
				entity:SetVizToNeutrals'Intel'
				entity:SetVizToEnemies'Intel'
				end
					if interval == 30 then 
						self:Destroy()
						entity:Destroy()
						local ShieldUnit =CreateUnitHPR('XRL0403', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
					end
					self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), '/mods/Commander Survival Kit/effects/emitters/nanites_01_emit.bp'):ScaleEmitter(3.0)
					self.Trash:Add(self.Effect1)
					self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), '/mods/Commander Survival Kit/effects/emitters/nanites_03_emit.bp'):ScaleEmitter(3.0)
					self.Trash:Add(self.Effect2)
					interval = interval + 1
					WaitSeconds(1)
                end
            end

        )
		StructureUnit.OnStopBeingBuilt(self,builder,layer)
    end,

}

TypeClass = UCRLN0403