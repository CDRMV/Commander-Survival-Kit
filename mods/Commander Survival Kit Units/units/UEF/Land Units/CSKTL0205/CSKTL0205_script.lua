#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0111/UEL0111_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Missile Launcher Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon

CSKTl0205 = Class(TLandUnit) {

    Weapons = {
        MainGun = Class(TDFMachineGunWeapon) {
        },
    },

	OnStopBeingBuilt = function(self,builder,layer)
		TLandUnit.OnStopBeingBuilt(self,builder,layer)
		BotMesh = '/mods/Commander Survival Kit Units/Decorations/T1Bot_mesh'
		self.Bot = import('/lua/sim/Entity.lua').Entity()
        self.Bot:AttachBoneTo( -1, self, 'Attachpoint' )
        self.Bot:SetMesh(BotMesh)
        self.Bot:SetDrawScale(0.0625)
        self.Bot:SetVizToAllies('Intel')
        self.Bot:SetVizToNeutrals('Intel')
        self.Bot:SetVizToEnemies('Intel')
    end,
	
}

TypeClass = CSKTl0205