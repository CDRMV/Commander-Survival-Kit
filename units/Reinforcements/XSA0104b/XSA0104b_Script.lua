#****************************************************************************
#**
#**  File     :  /cdimage/units/XSA0104/XSA0104_script.lua
#**  Author(s):  Greg Kohne, Aaron Lundquist
#**
#**  Summary  : Seraphim T2 Transport Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SAAShleoCannonWeapon = SeraphimWeapons.SAAShleoCannonWeapon
local SDFHeavyPhasicAutoGunWeapon = SeraphimWeapons.SDFHeavyPhasicAutoGunWeapon

XSA0104b = Class(SAirUnit) {

    AirDestructionEffectBones = { 'XSA0104','Left_Attachpoint08','Right_Attachpoint02'},

    Weapons = {
        AutoGun = Class(SDFHeavyPhasicAutoGunWeapon) {},
        AALeft = Class(SAAShleoCannonWeapon) {},
        AARight = Class(SAAShleoCannonWeapon) {},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        SAirUnit.OnStopBeingBuilt(self,builder,layer)
		
		LOG('*ATTACHING UNITS TO TRANS!!')
        local position = self:GetPosition()
		self.Station08 = CreateUnitHPR('xsl0101', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station08:AttachBoneTo(0, self, 'Left_Attachpoint01')
		self.Station09 = CreateUnitHPR('xsl0101', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station09:AttachBoneTo(0, self, 'Left_Attachpoint02')
		self.Station10 = CreateUnitHPR('xsl0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo(0, self, 'Left_Attachpoint03')
		self.Station08 = CreateUnitHPR('xsl0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station08:AttachBoneTo(0, self, 'Left_Attachpoint04')
		self.Station09 = CreateUnitHPR('xsl0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station09:AttachBoneTo(0, self, 'Left_Attachpoint05')
		self.Station10 = CreateUnitHPR('xsl0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo(0, self, 'Left_Attachpoint06')
		self.Station08 = CreateUnitHPR('xsl0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station08:AttachBoneTo(0, self, 'Left_Attachpoint07')
		self.Station09 = CreateUnitHPR('xsl0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station09:AttachBoneTo(0, self, 'Left_Attachpoint08')
		self.Station10 = CreateUnitHPR('xsl0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo(0, self, 'Right_Attachpoint01')
		self.Station08 = CreateUnitHPR('xsl0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station08:AttachBoneTo(0, self, 'Right_Attachpoint02')
		self.Station09 = CreateUnitHPR('xsl0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station09:AttachBoneTo(0, self, 'Right_Attachpoint03')
		self.Station10 = CreateUnitHPR('xsl0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo(0, self, 'Right_Attachpoint04')
		self.Station08 = CreateUnitHPR('xsl0104', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station08:AttachBoneTo(0, self, 'Right_Attachpoint05')
		self.Station09 = CreateUnitHPR('xsl0104', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station09:AttachBoneTo(0, self, 'Right_Attachpoint06')
		self.Station10 = CreateUnitHPR('xsl0104', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo(0, self, 'Right_Attachpoint07')
		self.Station08 = CreateUnitHPR('xsl0104', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station08:AttachBoneTo(0, self, 'Right_Attachpoint08')
    end,

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

TypeClass = XSA0104b