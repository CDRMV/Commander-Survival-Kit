#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0203/UEA0203_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  UEF Gunship Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local SDFUnstablePhasonBeam = import('/lua/seraphimweapons.lua').SDFUnstablePhasonBeam
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local ModEffectpath = '/mods/Commander Survival Kit Units/effects/emitters/'

UWX0100 = Class(TAirUnit) {

    Weapons = {
        Lightning = Class(SDFUnstablePhasonBeam) {},
		Lightning1 = Class(SDFUnstablePhasonBeam) {},
		Lightning2 = Class(SDFUnstablePhasonBeam) {},
		Lightning3 = Class(SDFUnstablePhasonBeam) {},
		Lightning4 = Class(SDFUnstablePhasonBeam) {},
		Lightning5 = Class(SDFUnstablePhasonBeam) {},
		Lightning6 = Class(SDFUnstablePhasonBeam) {},
		Lightning7 = Class(SDFUnstablePhasonBeam) {},
		Lightning8 = Class(SDFUnstablePhasonBeam) {},
		Lightning9 = Class(SDFUnstablePhasonBeam) {},
		Lightning10 = Class(SDFUnstablePhasonBeam) {},
		Lightning11 = Class(SDFUnstablePhasonBeam) {},
		Lightning12 = Class(SDFUnstablePhasonBeam) {},
		Lightning13 = Class(SDFUnstablePhasonBeam) {},
		Lightning14 = Class(SDFUnstablePhasonBeam) {},
		Lightning15 = Class(SDFUnstablePhasonBeam) {},
		Lightning16 = Class(SDFUnstablePhasonBeam) {},
		Lightning17 = Class(SDFUnstablePhasonBeam) {},
    },


    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
		self.Effect = CreateAttachedEmitter(self,'UEA0203',self:GetArmy(), ModEffectpath .. 'weather_cumulus_storm_02_emit.bp'):ScaleEmitter(2):OffsetEmitter(0,-30,0)
        self.Trash:Add(self.Effect)
		self.Effect1 = CreateAttachedEmitter(self,'UEA0203',self:GetArmy(), ModEffectpath .. 'weather_rainfall_01_emit.bp'):ScaleEmitter(2):OffsetEmitter(0,30,0)
        self.Trash:Add(self.Effect1)
		self:ForkThread(
            function()
                self.AimingNode = CreateRotator(self, 0, 'x', 0, 10000, 10000, 1000)
                WaitFor(self.AimingNode)
				local interval = 0
                while (interval < 61) do
				local orientation = RandomFloat(0,2*math.pi)
				local position = self:GetPosition()
				CreateDecal(position, orientation, '/mods/Commander Survival Kit Units/env/common/Tund_Snow_albedo.dds', '', 'Albedo', 200, 200, 5000, 0, self:GetArmy())
				WaitSeconds(3)
				LOG(interval)
					if interval == 60 then 
						self:Destroy()
					end
					interval = interval + 1
                end
            end
        )
	end,	
}

TypeClass = UWX0100