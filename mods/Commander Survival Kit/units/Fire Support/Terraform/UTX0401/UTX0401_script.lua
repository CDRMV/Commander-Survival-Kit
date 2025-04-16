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
local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )


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
		self:HideBone('UTX0401', true)
		self:ShakeCamera(20, 1, 0, 20)
		DamageArea(self, self:GetPosition(), 20, 50, 'Normal', false, false)
		WaitSeconds(10)
		self:ShakeCamera(20, 1, 0, 20)
		DamageArea(self, self:GetPosition(), 20, 50, 'Normal', false, false)
		local layer = self.Layer
		self.grow = 0
		local growing = true 
		self.height = 26
		self.position = self:GetPosition()
		self.Height = GetTerrainHeight(self.position[1], self.position[3])
		local seafloor = GetTerrainHeight(self.position[1], self.position[3]) + GetTerrainTypeOffset(self.position[1], self.position[3])
		seafloor = seafloor + seafloor
		local sqrt, sin, min, log10 = math.sqrt, math.sin, math.min, math.log10		
		self.sX, self.sZ = math.floor(decalposition[1]-seafloor), math.floor(decalposition[3]-seafloor)		
        self.eX, self.eZ = math.ceil(decalposition[1]+seafloor), math.ceil(decalposition[3]+seafloor)
		
		
		--------------------
		-- Setup Volcano Types
		--------------------
		self.Typegrowing = 0
		self.VolcanoHeight = 0
		local ShieldHeight = 10
		local StratoHeight = 18
		local Shieldgrowing = 7
		local Stratogrowing = 11
		---------------------
		---------------------
		
		
		local randomvolcanotype = math.random (1, 2)
		
		if randomvolcanotype == 1 then
		self.Typegrowing = Shieldgrowing
		self.VolcanoHeight = ShieldHeight
		Sync.ShieldVulcano = true
		elseif randomvolcanotype == 2 then
		self.Typegrowing = Stratogrowing
		self.VolcanoHeight = StratoHeight
		Sync.StratoVulcano = true
		end
		
		---------------------
		---------------------
		
		
		
		--[[
		
		'Default',
        'Desert',
        'Evergreen',
        'Geothermal',
        'Lava',
        'RedRock',
        'Tropical',
        'Tundra',
		
		]]--
		
		local pos = self:GetPosition()

	   
		self:SetScriptBit('RULEUTC_WeaponToggle', true)
		
		while true do
		local Vulcano = import('/mods/Commander Survival Kit/UI/Layout/Values.lua').Vulcano
		if Vulcano == true then
		local sqrt, sin, min, log10 = math.sqrt, math.sin, math.min, math.log10	
		for x = self.sX, self.eX do    
                if x<0 or x>ScenarioInfo.size[1] then continue end
                for z = self.sZ, self.eZ do
                    if z<0 or z>ScenarioInfo.size[2] then continue end
                    local dSq = VDist2Sq(x, z, self.position[1], self.position[3])
                    if dSq <= self.height*self.height then
                        local relD = sin(1-(sqrt(dSq)/self.height))
                        local maxD = self.VolcanoHeight
                        local curD = self.Height
                            local target = curD + (relD*maxD)  
                                FlattenMapRect(x, z, 0, 0, target)	
								local Crater = 0 			
                    local dSq2 = VDist2Sq(x, z, self.position[1], self.position[3])
                    if dSq2 <= 4*4 then
						if Crater < 60 then							
                        local relD2 = sin(1-(sqrt(dSq2)/4) + 10)
                        local maxD2 = min(6, log10(4) - 3)
                        local curD2 = GetTerrainHeight(self.position[1] - 4, self.position[3] + 4)
						local target2 = curD2 - (relD/maxD) 
								FlattenMapRect(x, z, 0, 0, target2 -1)
											Crater = Crater + 1	
										
						else			
						end	
                    end
                end
            end
		end
		end
		WaitSeconds(0.1)
		end
		end	
		)		
    end,
	
	
	OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
				local orientation = RandomFloat(0,2*math.pi)
		local position = self:GetPosition()
		local qx, qy, qz, qw = unpack(self:GetOrientation())
		local interval = 0
        		self:ForkThread(
        function()
		self:HideBone('UTX0401', true)
		self:ShakeCamera(20, 1, 0, 20)
		WaitSeconds(5)
		self:ShakeCamera(20, 1, 0, 20)
		local number = 0
		while true do
				self.AimingNode = CreateRotator(self, 0, 'x', 0, 10000, 10000, 1000)
        WaitFor(self.AimingNode)
		self:GetWeaponByLabel'Turret01':FireWeapon()
				DamageArea(self, self:GetPosition(), 25, 50, 'Fire', false, false)
			WaitSeconds(0.1)
		if number == 0 then	
		local terrainType = GetTerrainType( position[1], position[3] )
						if terrainType.Style == 'Evergreen' or terrainType.Style == 'Tropical' or terrainType.Style == 'Default' or terrainType.Style == nil then
		self.Decal = CreateDecal(position, orientation, '/mods/Commander Survival Kit/textures/particles/vulcano_normal.dds', '', 'Albedo', 60, 60, 600, 0, self:GetArmy())
		elseif terrainType.Style == 'Tundra' then
		self.Decal = CreateDecal(position, orientation, '/mods/Commander Survival Kit/textures/particles/vulcano_ice.dds', '', 'Albedo', 50, 50, 600, 0, self:GetArmy())
		elseif terrainType.Style == 'Desert' or terrainType.Style == 'Geothermal' or terrainType.Style == 'Lava' or terrainType.Style == 'RedRock' then
		self.Decal = CreateDecal(position, orientation, '/mods/Commander Survival Kit/textures/particles/vulcano_desert.dds', '', 'Albedo', 50, 50, 600, 0, self:GetArmy())
		end
		self.Effect1 = CreateAttachedEmitter(self,'UTX0401',self:GetArmy(), ModEffectpath .. 'lava_fontaene_01_emit.bp'):ScaleEmitter(15):OffsetEmitter(0,-20,0)
        # Create projectile that controls plume effects
        local PlumeEffectYOffset = 1
        self.Effect2 = self:CreateProjectileAtBone('/mods/Commander Survival Kit/effects/Entities/VolcanoEruptionEffect01/VolcanoEruptionEffect01_proj.bp','Eruption1')        
        
		self.Decal1 = CreateDecal(position, orientation, '/mods/Commander Survival Kit/textures/particles/lavaflow_albedo.dds', '', 'Albedo', 50, 50, 600, 0, self:GetArmy())
		number = number + 1
		end			
			if interval == 10 then
			--CreateUnit('UTX0400',1,position[1]+4, position[2]+4, position[3]+4,qx, qy, qz, qw, 0)
			end 
			if interval == 300 then 

		self.Effect1:Destroy()
		self.Effect2:Destroy()
		self.Decal1:Destroy()
		WaitSeconds(200)
		self:ShakeCamera(20, 1, 0, 20)
		WaitSeconds(50)
		self:ShakeCamera(50, 1, 0, 20)
		WaitSeconds(50)
		self:ShakeCamera(100, 1, 0, 20)
				number = 0
				interval = 0
				else
						interval = interval + 1
			end
		end	
		
		end	
		)	
    end,
	
	
		DeletesProps = function(self)  
        local blueprint = self:GetBlueprint()
        local physics = blueprint.Physics
        local footprint = blueprint.Footprint
        local x, _, z = self:GetPositionXYZ()
        local fx = x - footprint.SizeX * .5
        local fz = z - footprint.SizeZ * .5
        local sx = fx + physics.SkirtOffsetX
        local sz = fz + physics.SkirtOffsetZ		
				local ents = GetEntitiesInRect(sx, sz, sx + blueprint.Physics.SkirtSizeX, sz + blueprint.Physics.SkirtSizeZ)
					for i, e in ents do
                        if IsProp(e) then
							e:Destroy()
                        end
                    end	
end,

	OnScriptBitSet = function(self, bit)
        StructureUnit.OnScriptBitSet(self, bit)
		local sqrt, sin, min, log10 = math.sqrt, math.sin, math.min, math.log10	
        if bit == 1 then 
		ForkThread( function()
		WaitSeconds(1)
		if self.grow < self.Typegrowing + 0.01 then
            for x = self.sX, self.eX do
                if x<0 or x>ScenarioInfo.size[1] then continue end
                for z = self.sZ, self.eZ do
                    if z<0 or z>ScenarioInfo.size[2] then continue end
                    local dSq = VDist2Sq(x, z, self.position[1], self.position[3])
                    if dSq <= self.height*self.height then
                        local relD = sin(1-(sqrt(dSq)/self.height))
                        local maxD = min(self.height*8, log10(self.height))
                        local curD = GetTerrainHeight(x, z) + GetTerrainTypeOffset(x, z)
                            local target = curD + (relD*maxD)
                                FlattenMapRect(x, z, 0, 0, target)
								local Crater = 0 			
                    local dSq2 = VDist2Sq(x, z, self.position[1], self.position[3])
                    if dSq2 <= 4*4 then
						if Crater < 60 then							
                        local relD2 = sin(1-(sqrt(dSq2)/4) + 10)
                        local maxD2 = min(6, log10(4) - 3)
                        local curD2 = GetTerrainHeight(self.position[1] - 4, self.position[3] + 4)
						local target2 = curD2 - (relD/maxD) 
								FlattenMapRect(x, z, 0, 0, target2 -1)
											Crater = Crater + 1	
																						
						else			
						end	
                    end
                end
            end

		end
		self.grow = self.grow + 1
		if self.grow == self.Typegrowing then

		else
		self:SetScriptBit('RULEUTC_WeaponToggle', false)
		end
            end
			end
        )
        end
    end,

    OnScriptBitClear = function(self, bit)
        StructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		ForkThread( function()
			self:SetScriptBit('RULEUTC_WeaponToggle', true)
            end
        )
        end
    end,

}

TypeClass = UTX0401