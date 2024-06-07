#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0201/UEL0201_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Medium Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local LandUnit = import('/lua/defaultunits.lua').LandUnit
local ModEffectpath = '/mods/Commander Survival Kit Units/effects/emitters/'
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

UTX0400 = Class(LandUnit) {

	OnStopBeingBuilt = function(self,builder,layer)
        LandUnit.OnStopBeingBuilt(self,builder,layer)
		self:HideBone('UEL0201', true)
		local orientation = RandomFloat(0,2*math.pi)
		local position = self:GetPosition()
		CreateSplatOnBone(self, {0,0,0}, 'UEL0201', '/mods/Commander Survival Kit Units/textures/lavacold_albedo.dds', 1.4, 1.4, 1200, 0, self:GetArmy())
		CreateSplatOnBone(self, {0,0,0}, 'UEL0201', '/mods/Commander Survival Kit Units/textures/lava2_albedo.dds', 1.4, 1.4, 1200, 100, self:GetArmy())
		CreateSplatOnBone(self, {0,0,0}, 'UEL0201', '/mods/Commander Survival Kit Units/textures/lava_albedo.dds', 1.4, 1.4, 1200, 200, self:GetArmy())
		ForkThread( function()
			WaitSeconds(20)
			self:Destroy()
		end)
    end,
	
	
	OnLayerChange = function(self, new, old)
        LandUnit.OnLayerChange(self, new, old)
            if (new == 'Land') and (old != 'None') then
			
            elseif (new == 'Seabed') then
				ForkThread( function()
				while true do
				WaitSeconds(2)
				self:Destroy()
				end
				end)
            end
    end,
	
	OnMotionHorzEventChange = function(self, new, old)
        LandUnit.OnMotionHorzEventChange(self, new, old)
		ForkThread( function()
		if old == 'Stopped' then
		while true do
		local orientation = RandomFloat(0,2*math.pi)
		local position = self:GetPosition()
		local surface = GetSurfaceHeight(position[1], position[3])
		local terrain = GetTerrainHeight(position[1], position[3])
		if terrain >= surface then
		WaitSeconds(0.4)
		CreateSplatOnBone(self, {0,0,0}, 'UEL0201', '/mods/Commander Survival Kit Units/textures/lavacold_albedo.dds', 1.4, 1.4, 1200, 1000, self:GetArmy())
		else
		WaitSeconds(0.4)
		CreateSplatOnBone(self, {0,0,0}, 'UEL0201', '/mods/Commander Survival Kit Units/textures/lavacold_albedo.dds', 1.4, 1.4, 1200, 1000, self:GetArmy())
		end
		end
        elseif new == 'Stopped' then
		while true do
		local orientation = RandomFloat(0,2*math.pi)
		local position = self:GetPosition()
		local surface = GetSurfaceHeight(position[1], position[3])
		local terrain = GetTerrainHeight(position[1], position[3])
		if terrain >= surface then
		WaitSeconds(0.4)
		CreateSplatOnBone(self, {0,0,0}, 'UEL0201', '/mods/Commander Survival Kit Units/textures/lavacold_albedo.dds', 1.4, 1.4, 1200, 1000, self:GetArmy())
		else
		WaitSeconds(0.4)
		CreateSplatOnBone(self, {0,0,0}, 'UEL0201', '/mods/Commander Survival Kit Units/textures/lavacold_albedo.dds', 1.4, 1.4, 1200, 1000, self:GetArmy())
		end
		end
		end
		end)
    end,

}

TypeClass = UTX0400