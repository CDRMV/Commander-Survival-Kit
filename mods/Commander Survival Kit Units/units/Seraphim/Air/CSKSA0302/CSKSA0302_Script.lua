#****************************************************************************
#**
#**  File     :  /cdimage/units/XSA0104/XSA0104_script.lua
#**  Author(s):  Greg Kohne, Aaron Lundquist
#**
#**  Summary  : Seraphim T2 Transport Script
#**
#**  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SAAShleoCannonWeapon = SeraphimWeapons.SAAShleoCannonWeapon
local SIFBombZhanaseeWeapon = SeraphimWeapons.SIFBombZhanaseeWeapon

XSA0104 = Class(SAirUnit) {

    AirDestructionEffectBones = { 'CSKSA0302'},

    Weapons = {
		Bomb = Class(SIFBombZhanaseeWeapon) {},
        AALeft = Class(SAAShleoCannonWeapon) {},
        AARight = Class(SAAShleoCannonWeapon) {},
    },

    # Override air destruction effects so we can do something custom here
    CreateUnitAirDestructionEffects = function( self, scale )
        self:ForkThread(self.AirDestructionEffectsThread, self )
    end,

    AirDestructionEffectsThread = function( self )
        local numExplosions = math.floor( table.getn( self.AirDestructionEffectBones ) * 0.5 )
        for i = 0, numExplosions do
            explosion.CreateDefaultHitExplosionAtBone( self, self.AirDestructionEffectBones[util.GetRandomInt( 1, numExplosions )], 0.5 )
            WaitSeconds( util.GetRandomFloat( 0.2, 0.9 ))
        end
    end,
}

TypeClass = XSA0104