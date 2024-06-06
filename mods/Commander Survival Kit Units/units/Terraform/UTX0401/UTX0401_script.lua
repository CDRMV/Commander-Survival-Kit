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

UTX0401 = Class(StructureUnit) {
    Weapons = {
        Turret01 = Class(DefaultProjectileWeapon) {},
    },
	
	
    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
        self.Effect1 = CreateAttachedEmitter(self,'UTX0400',self:GetArmy(), ModEffectpath .. 'vulcano_smoke_01_emit.bp'):ScaleEmitter(10):OffsetEmitter(0,-10,0)
        self.Trash:Add(self.Effect1)
		self.Effect2 = CreateAttachedEmitter(self,'UTX0400',self:GetArmy(), ModEffectpath .. 'vulcano_smoke_01_emit.bp'):ScaleEmitter(10):OffsetEmitter(0,-10,0)
        self.Trash:Add(self.Effect2)
		self.Effect3 = CreateAttachedEmitter(self,'UTX0400',self:GetArmy(), ModEffectpath .. 'lava_fontaene_01_emit.bp'):ScaleEmitter(9):OffsetEmitter(0,-5,0)
        self.Trash:Add(self.Effect3)
		local orientation = RandomFloat(0,2*math.pi)
		local position = self:GetPosition()
		CreateDecal(position, orientation, '/mods/Commander Survival Kit Units/textures/volcan_albedo2.dds', '', 'Albedo', 50, 50, 1200, 0, self:GetArmy())
	local height = 18
	
		self:ForkThread(
            function()
			    local bp = self:GetBlueprint()
                self.AimingNode = CreateRotator(self, 0, 'x', 0, 10000, 10000, 1000)
                WaitFor(self.AimingNode)
				local interval = 0
				local grow = 0
                while (interval < 61) do

					if interval == 60 then 
						self:Destroy()
					end
								local sqrt, sin, min, log10 = math.sqrt, math.sin, math.min, math.log10
			if grow > 8 then
					local num = Ceil((R()+R()+R()+R()+R()+R()+R()+R()+R()+R()+R())*R(1,10))
                    coroutine.yield(num)#
                    self:GetWeaponByLabel'Turret01':FireWeapon()
					else
			local sX, sZ = math.floor(position[1]-height), math.floor(position[3]-height)
            local eX, eZ = math.ceil(position[1]+height), math.ceil(position[3]+height)
            for x=sX, eX do
                if x<0 or x>ScenarioInfo.size[1] then continue end
                for z=sZ, eZ do
                    if z<0 or z>ScenarioInfo.size[2] then continue end
                    local dSq = VDist2Sq(x, z, position[1], position[3])
                    if dSq <= height*height then
                        local relD = sin(1-(sqrt(dSq)/height))
                        local maxD = min(height*0.5, log10(height))
                        local curD = GetTerrainHeight(x, z)
                            local target = curD + (relD*maxD)
                                FlattenMapRect(x, z, 0, 0, target)
							
						
                    end
                end
            end
                    local num = Ceil((R()+R()+R()+R()+R()+R()+R()+R()+R()+R()+R())*R(1,10))
                    coroutine.yield(num)
                    self:GetWeaponByLabel'Turret01':FireWeapon()
		    local sX2, sZ2 = math.floor(position[1]-4), math.floor(position[3]-4)
            local eX2, eZ2 = math.ceil(position[1]+4), math.ceil(position[3]+4)
            for x=sX2, eX2 do
                if x<0 or x>ScenarioInfo.size[1] then continue end
                for z=sZ2, eZ2 do
                    if z<0 or z>ScenarioInfo.size[2] then continue end
                    local dSq2 = VDist2Sq(x, z, position[1], position[3])
                    if dSq2 <= 4*4 then
                        local relD2 = sin(1-(sqrt(dSq2)/4) + 0.1)
                        local maxD2 = min(6, log10(4) + 0.1)
                        local curD2 = GetTerrainHeight(x, z)
						local target2 = position[2]-(relD2*maxD2)
							if grow == 0 then
								FlattenMapRect(x, z, 0, 0, target2)
							else
                                FlattenMapRect(x, z, 0, 0, curD2)
							end	
						
                    end
                end
            end
					grow = grow + 1
			end		
					interval = interval + 1
                end
            end
        )
    end,

}

TypeClass = UTX0401