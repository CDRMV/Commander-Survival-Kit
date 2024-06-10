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
	
	--[[
	-- Flattenskirt Load for other purposes
	OnCreate = function(self)
        StructureUnit.OnCreate(self)
		local interval = 0
		local grow = 0
		local growing = 0
								local position = self:GetPosition()
		local Height = GetTerrainHeight(position[1], position[3])
			local sqrt, sin, min, log10 = math.sqrt, math.sin, math.min, math.log10		
			local sX, sZ = math.floor(position[1]-Height), math.floor(position[3]-Height)
            local eX, eZ = math.ceil(position[1]+Height), math.ceil(position[3]+Height)
		self:ForkThread(
            function()
		while true do
		WaitSeconds(0.1)
		FlattenMapRect(position[1]-15, position[3]-15, 26, 26, 0)
		end 
		end		
		)		
    end,
	]]--

	
    OnCreate = function(self)
        StructureUnit.OnCreate(self)
		local decalposition = self:GetPosition()
		self.DeletesProps(self)
		self:ForkThread(
        function()
		local layer = self.Layer
		local grow = 0
		local growing = 0 
		local height = 14
		local position = self:GetPosition()
		local Height = GetTerrainHeight(position[1], position[3])
		local seafloor = GetTerrainHeight(position[1], position[3]) + GetTerrainTypeOffset(position[1], position[3])
			local sqrt, sin, min, log10 = math.sqrt, math.sin, math.min, math.log10		
					local sX, sZ = math.floor(decalposition[1]-seafloor), math.floor(decalposition[3]-seafloor)
        local eX, eZ = math.ceil(decalposition[1]+seafloor), math.ceil(decalposition[3]+seafloor)
		local orientation = RandomFloat(0,2*math.pi)
		local qx, qy, qz, qw = unpack(self:GetOrientation())
		CreateDecal(decalposition, orientation, '/mods/Commander Survival Kit Units/textures/volcan_albedo2.dds', '', 'Albedo', 50, 50, 1200, 0, self:GetArmy())
        self.Effect1 = CreateAttachedEmitter(self,'UTX0400',self:GetArmy(), ModEffectpath .. 'vulcano_smoke_01_emit.bp'):ScaleEmitter(10):OffsetEmitter(0,-10,0)
        self.Trash:Add(self.Effect1)
		self.Effect2 = CreateAttachedEmitter(self,'UTX0400',self:GetArmy(), ModEffectpath .. 'vulcano_smoke_01_emit.bp'):ScaleEmitter(10):OffsetEmitter(0,-10,0)
        self.Trash:Add(self.Effect2)
		self.Effect3 = CreateAttachedEmitter(self,'UTX0400',self:GetArmy(), ModEffectpath .. 'lava_fontaene_01_emit.bp'):ScaleEmitter(10):OffsetEmitter(0,-10,0)
        self.Trash:Add(self.Effect3)
		self.Effect3 = CreateAttachedEmitter(self,'UTX0400',self:GetArmy(), ModEffectpath .. 'lava_fontaene_01_emit.bp'):ScaleEmitter(10):OffsetEmitter(2,-10,0)
        self.Trash:Add(self.Effect3)
		self.Effect3 = CreateAttachedEmitter(self,'UTX0400',self:GetArmy(), ModEffectpath .. 'lava_fontaene_01_emit.bp'):ScaleEmitter(10):OffsetEmitter(-2,-10,0)
        self.Trash:Add(self.Effect3)
		self.Effect3 = CreateAttachedEmitter(self,'UTX0400',self:GetArmy(), ModEffectpath .. 'lava_fontaene_01_emit.bp'):ScaleEmitter(10):OffsetEmitter(0,-10,2)
        self.Trash:Add(self.Effect3)
		self.Effect3 = CreateAttachedEmitter(self,'UTX0400',self:GetArmy(), ModEffectpath .. 'lava_fontaene_01_emit.bp'):ScaleEmitter(10):OffsetEmitter(0,-10,-2)
        self.Trash:Add(self.Effect3)
		self.Effect = CreateAttachedEmitter(self,'UTX0400',self:GetArmy(), '/effects/emitters/weather_cumulus_storm_02_emit.bp'):ScaleEmitter(2):OffsetEmitter(0,30,0)
        self.Trash:Add(self.Effect)
		self.Effect = CreateAttachedEmitter(self,'UTX0400',self:GetArmy(), '/effects/emitters/weather_cumulus_storm_02_emit.bp'):ScaleEmitter(2):OffsetEmitter(0,30,0)
        self.Trash:Add(self.Effect)
		self.Effect = CreateAttachedEmitter(self,'UTX0400',self:GetArmy(), '/effects/emitters/weather_cumulus_storm_02_emit.bp'):ScaleEmitter(2):OffsetEmitter(0,30,0)
        self.Trash:Add(self.Effect)
		self.Effect3 = CreateAttachedEmitter(self,'UTX0400',self:GetArmy(), '/effects/emitters/weather_rainfall_01_emit.bp'):ScaleEmitter(2):OffsetEmitter(0,30,0)
        self.Trash:Add(self.Effect3)
		CreateDecal(decalposition, orientation, '/mods/Commander Survival Kit Units/textures/lavaflow_albedo.dds', '', 'Albedo', 50, 50, 1200, 0, self:GetArmy())
		CreateDecal(decalposition, orientation, '/mods/Commander Survival Kit Units/textures/lava_albedo.dds', '', 'Albedo', 10, 10, 1200, 0, self:GetArmy())
		while true do
		WaitSeconds(1)
		while grow >= 7 do 
		WaitSeconds(1)
            for x=sX, eX do    
                if x<0 or x>ScenarioInfo.size[1] then continue end
                for z=sZ, eZ do
                    if z<0 or z>ScenarioInfo.size[2] then continue end
                    local dSq = VDist2Sq(x + 600, z + 600, position[1], position[3])
                    if dSq <= height*height then
                        local relD = sin(1-(sqrt(dSq)/height))
                        local maxD = min(height*4, log10(566231040 * 50))
                        local curD = Height
                            local target = curD + (relD*maxD) 
                                FlattenMapRect(x, z, 0, 0, target)	
								local Crater = 0 			
                    local dSq2 = VDist2Sq(x, z, position[1], position[3])
                    if dSq2 <= 4*4 then
						if Crater < 60 then							
                        local relD2 = sin(1-(sqrt(dSq2)/4) + 10)
                        local maxD2 = min(6, log10(4) - 3)
                        local curD2 = GetTerrainHeight(position[1] - 4, position[3] + 4)
						local target2 = curD2 - (relD/maxD) 
								FlattenMapRect(x, z, 0, 0, target2 -1)
											Crater = Crater + 1	
										
						else			
						end	
                    end
                end
            end
		end
		grow = grow + 1
		end
		while grow < 8 do
		WaitSeconds(1)
            for x=sX, eX do
                if x<0 or x>ScenarioInfo.size[1] then continue end
                for z=sZ, eZ do
                    if z<0 or z>ScenarioInfo.size[2] then continue end
                    local dSq = VDist2Sq(x, z, position[1], position[3])
                    if dSq <= height*height then
                        local relD = sin(1-(sqrt(dSq)/height))
                        local maxD = min(height*8, log10(height))
                        local curD = GetTerrainHeight(x, z) + GetTerrainTypeOffset(x, z)
                            local target = curD + (relD*maxD)
                                FlattenMapRect(x, z, 0, 0, target)
								local Crater = 0 			
                    local dSq2 = VDist2Sq(x, z, position[1], position[3])
                    if dSq2 <= 4*4 then
						if Crater < 60 then							
                        local relD2 = sin(1-(sqrt(dSq2)/4) + 10)
                        local maxD2 = min(6, log10(4) - 3)
                        local curD2 = GetTerrainHeight(position[1] - 4, position[3] + 4)
						local target2 = curD2 - (relD/maxD) 
								FlattenMapRect(x, z, 0, 0, target2 -1)
											Crater = Crater + 1	
																						
						else			
						end	
                    end
                end
            end

		end
		grow = grow + 1
		end
		end
		end	
		)		
    end,
	
	
	OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
		local position = self:GetPosition()
		local qx, qy, qz, qw = unpack(self:GetOrientation())
		local interval = 0
        		self:ForkThread(
        function()
		self.AimingNode = CreateRotator(self, 0, 'x', 0, 10000, 10000, 1000)
        WaitFor(self.AimingNode)
				while true do
				WaitSeconds(1)
		LOG(interval)
		local num = Ceil((R()+R()+R()+R()+R()+R()+R()+R()+R()+R()+R())*R(1,10))
        coroutine.yield(num)
        self:GetWeaponByLabel'Turret01':FireWeapon()
			if interval == 10 then
				CreateUnit('UTX0400',1,position[1]+4, position[2]+4, position[3]+4,qx, qy, qz, qw, 0)
			end 
			if interval == 60 then 
				interval = 0
				else
						interval = interval + 1
			end
		end	
		end	
		)	
    end,
	
		DeletesProps = function(self)                               
                local ents = GetEntitiesInRect(self:GetSkirtRect())
					for i, e in ents do
                        if IsProp(e) then
							e:Destroy()
                        end
                    end
end,

}

TypeClass = UTX0401