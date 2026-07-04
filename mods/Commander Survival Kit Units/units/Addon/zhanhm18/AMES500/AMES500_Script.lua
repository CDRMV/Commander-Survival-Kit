#****************************************************************************
#**
#**  File     :  /cdimage/units/XES0402/XES0402_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Battleship Script
#**
#**  Copyright ?2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TSeaUnit = import('/lua/defaultunits.lua').MobileUnit
local WeaponsFile = import('/lua/terranweapons.lua')


local TDFGaussCannonWeapon = WeaponsFile.TDFShipGaussCannonWeapon
local TIFCruiseMissileLauncher = WeaponsFile.TIFCruiseMissileLauncher
local TANTorpedoAngler = import('/lua/terranweapons.lua').TANTorpedoAngler
local TDFHiroPlasmaCannon = WeaponsFile.TDFHiroPlasmaCannon
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher
local TIFArtilleryWeapon = import("/lua/terranweapons.lua").TIFArtilleryWeapon
local CAAMissileNaniteWeapon = import('/lua/cybranweapons.lua').CAAMissileNaniteWeapon


local EffectUtils = import('/lua/effectutilities.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Effects = import('/lua/effecttemplates.lua')
local explosion = import('/lua/defaultexplosions.lua')
local Entity = import('/lua/sim/Entity.lua').Entity


XES0402MK = Class(TSeaUnit) {


    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 3.5,},
	MissileRack = Class(TSAMLauncher) {},
   
        Torpedo01 = Class(TANTorpedoAngler) {},
        Torpedo02 = Class(TANTorpedoAngler) {},
         Missile = Class(TSAMLauncher) {},

        GaussCannona = Class(TDFGaussCannonWeapon) {},
        GaussCannonb = Class(TDFGaussCannonWeapon) {},
        GaussCannonc = Class(TDFGaussCannonWeapon) {},
        GaussCannond = Class(TDFGaussCannonWeapon) {},
        CruiseMissilea = Class(TIFCruiseMissileLauncher) {            },
           CruiseMissilea01a = Class(TIFCruiseMissileLauncher) {            },

        CruiseMissile = Class(TIFCruiseMissileLauncher) {},
    },


}

TypeClass = XES0402MK