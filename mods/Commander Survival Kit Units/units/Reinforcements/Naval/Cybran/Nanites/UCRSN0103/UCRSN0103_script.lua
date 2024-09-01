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

UCRSN0103 = Class(StructureUnit) {
    Weapons = {
        Nanites = Class(DefaultProjectileWeapon) {},
    },
	
    OnStopBeingBuilt = function(self,builder,layer)
					local location = self:GetPosition()
		local SurfaceHeight = GetSurfaceHeight(location[1], location[3]) -- Get Water layer
		local TerrainHeight = GetTerrainHeight(location[1], location[3]) -- Get Land Layer
		LOG("Water: ", SurfaceHeight)
		LOG("Land: ", TerrainHeight)
		
		-- Check for preventing Land Reinforcements to be spawned in the Water.
		if SurfaceHeight == TerrainHeight then 
		
		else

		self:ForkThread(
            function()
				local interval = 0
				        local entity = import('/lua/sim/Entity.lua').Entity()
                while (interval < 11) do
				LOG(interval)
				if interval == 2 then
				entity:SetPosition(Vector(location[1], location[2], location[3]), true)
				entity:SetMesh('/mods/Commander Survival Kit/meshes/Cybran/Frigate_Mesh')
				entity:SetDrawScale(0.09)
				entity:SetVizToAllies'Intel'
				entity:SetVizToNeutrals'Intel'
				entity:SetVizToEnemies'Intel'
				end
					if interval == 10 then 
						self:Destroy()
						entity:Destroy()
						local ShieldUnit =CreateUnitHPR('URS0103', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
					end
					self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), '/mods/Commander Survival Kit/effects/emitters/nanites_01_emit.bp')
					self.Trash:Add(self.Effect1)
					self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), '/mods/Commander Survival Kit/effects/emitters/nanites_03_emit.bp')
					self.Trash:Add(self.Effect2)
					interval = interval + 1
					WaitSeconds(1)
                end
            end

        )
		end
		StructureUnit.OnStopBeingBuilt(self,builder,layer)
    end,

}

TypeClass = UCRSN0103