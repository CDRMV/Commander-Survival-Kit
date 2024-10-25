#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0203/UEA0203_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  UEF Gunship Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local WeaponsFile = import ('/lua/seraphimweapons.lua')
local TornadoBeam2 = import('/mods/Commander Survival Kit/lua/FireSupportBarrages.lua').TornadoBeam2
local SDFUnstablePhasonBeam = import('/lua/seraphimweapons.lua').SDFUnstablePhasonBeam
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local ModEffectpath = '/mods/Commander Survival Kit/effects/emitters/'

UWX0400 = Class(TAirUnit) {

    Weapons = {
        Tornado = Class(TornadoBeam2) {},
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
		self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'smoke_cloud_01_emit.bp'):ScaleEmitter(30)
		self.Trash:Add(self.Effect1)
		self.Effect2 = CreateAttachedEmitter(self,'Muzzle.001',self:GetArmy(), '/effects/emitters/weather_rainfall_01_emit.bp'):ScaleEmitter(3):OffsetEmitter(0,-30,0)
        self.Trash:Add(self.Effect2)
		self:ForkThread(
            function()
                self.AimingNode = CreateRotator(self, 0, 'x', 0, 10000, 10000, 1000)
                WaitFor(self.AimingNode)
				local interval = 0
                while (interval < 3) do
				LOG(interval)
					if interval == 2 then 
						self:Destroy()
					end
                    local num = Ceil((R()+R()+R()+R()+R()+R()+R()+R()+R()+R()+R())*R(1,10))
                    coroutine.yield(num)
					self:GetWeaponByLabel'Tornado':FireWeapon()
					WaitSeconds(3)
					self:GetWeaponByLabel'Lightning5':FireWeapon()
					WaitSeconds(3)
					self:GetWeaponByLabel'Lightning2':FireWeapon()
					WaitSeconds(3)
					self:GetWeaponByLabel'Lightning4':FireWeapon()
					WaitSeconds(3)
					self:GetWeaponByLabel'Lightning3':FireWeapon()
					WaitSeconds(3)
					self:GetWeaponByLabel'Lightning6':FireWeapon()
					WaitSeconds(3)
					self:GetWeaponByLabel'Lightning9':FireWeapon()
					WaitSeconds(3)
					self:GetWeaponByLabel'Lightning7':FireWeapon()
					WaitSeconds(3)
					self:GetWeaponByLabel'Lightning10':FireWeapon()
					WaitSeconds(3)
					self:GetWeaponByLabel'Lightning8':FireWeapon()
					WaitSeconds(3)
					self:GetWeaponByLabel'Lightning12':FireWeapon()
					WaitSeconds(3)
					self:GetWeaponByLabel'Lightning15':FireWeapon()
					WaitSeconds(3)
					self:GetWeaponByLabel'Lightning11':FireWeapon()
					WaitSeconds(3)
					self:GetWeaponByLabel'Lightning17':FireWeapon()
					WaitSeconds(3)
					self:GetWeaponByLabel'Lightning14':FireWeapon()
					WaitSeconds(3)
					self:GetWeaponByLabel'Lightning16':FireWeapon()
					WaitSeconds(3)
					self:GetWeaponByLabel'Lightning13':FireWeapon()
					WaitSeconds(3)
					interval = interval + 1
                end
            end
        )
	end,	
}

TypeClass = UWX0400