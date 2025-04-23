#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0201/UEL0201_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Medium Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local LandUnit = import('/lua/defaultunits.lua').MobileUnit
local ModEffectpath = '/mods/Commander Survival Kit/effects/emitters/'
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

CSKUUTX0400 = Class(LandUnit) {

	OnStopBeingBuilt = function(self,builder,layer)
        LandUnit.OnStopBeingBuilt(self,builder,layer)
		self:HideBone('UEL0201', true)
		self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'smoke_cloud_01_emit.bp'):ScaleEmitter(1)
		self.Trash:Add(self.Effect1)
		DamageArea(self, self:GetPosition(), self:GetBlueprint().Intel.VisionRadius, 500, 'Fire', false, false)
		ForkThread( function()
			WaitSeconds(20)
			self:Destroy()
		end)
    end,
	
	
	
	OnMotionHorzEventChange = function(self, new, old)
        LandUnit.OnMotionHorzEventChange(self, new, old)
		ForkThread( function()
		if old == 'Stopped' then
		while true do
		WaitSeconds(1)
		local position = self:GetPosition()
		local qx, qy, qz, qw = unpack(self:GetOrientation())
		CreateUnit('UTX0402',1,position[1], position[2], position[3],qx, qy, qz, qw, 0)
		end
        elseif new == 'Stopped' then
		while true do
		WaitSeconds(1)
		local position = self:GetPosition()
		local qx, qy, qz, qw = unpack(self:GetOrientation())
		CreateUnit('UTX0402',1,position[1], position[2], position[3],qx, qy, qz, qw, 0)
		end
		end
		end)
    end,

}

TypeClass = CSKUUTX0400