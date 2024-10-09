#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0104/UAA0104_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Aeon T2 Transport Script
#**
#**  Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/defaultunits.lua').AirUnit
local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')
local AAASonicPulseBatteryWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon

UAA0104b = Class(AAirUnit) {

    AirDestructionEffectBones = { 'Exhaust', 'Wing_Right', 'Wing_Left', 'Turret_Right', 'Turret_Left',
                                  'Slots_Left01', 'Slots_Left02', 'Slots_Right01', 'Slots_Right02',
                                  'Right_AttachPoint01', 'Right_AttachPoint02', 'Right_AttachPoint03', 'Right_AttachPoint04',
                                  'Left_AttachPoint01', 'Left_AttachPoint02', 'Left_AttachPoint03', 'Left_AttachPoint04', },

    Weapons = {
        SonicPulseBattery1 = Class(AAASonicPulseBatteryWeapon) {},
        SonicPulseBattery2 = Class(AAASonicPulseBatteryWeapon) {},
        SonicPulseBattery3 = Class(AAASonicPulseBatteryWeapon) {},
        SonicPulseBattery4 = Class(AAASonicPulseBatteryWeapon) {},
    },

	OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
        LOG('*ATTACHING UNITS TO TRANS!!')
        local position = self:GetPosition()
		
		self.Station08 = CreateUnitHPR('ual0106', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station08:AttachBoneTo(0, self, 'Left_Attachpoint01')
		self.Station09 = CreateUnitHPR('ual0106', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station09:AttachBoneTo(0, self, 'Left_Attachpoint02')
		self.Station10 = CreateUnitHPR('ual0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo(0, self, 'Left_Attachpoint03')
		self.Station11 = CreateUnitHPR('ual0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station11:AttachBoneTo(0, self, 'Left_Attachpoint04')
		self.Station10 = CreateUnitHPR('ual0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo(0, self, 'Left_Attachpoint05')
		self.Station11 = CreateUnitHPR('ual0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station11:AttachBoneTo(0, self, 'Left_Attachpoint06')
		self.Station08 = CreateUnitHPR('ual0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station08:AttachBoneTo(0, self, 'Right_Attachpoint01')
		self.Station09 = CreateUnitHPR('ual0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station09:AttachBoneTo(0, self, 'Right_Attachpoint02')
		self.Station10 = CreateUnitHPR('ual0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo(0, self, 'Right_Attachpoint03')
		self.Station11 = CreateUnitHPR('ual0104', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station11:AttachBoneTo(0, self, 'Right_Attachpoint04')
		self.Station10 = CreateUnitHPR('ual0104', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo(0, self, 'Right_Attachpoint05')
		self.Station11 = CreateUnitHPR('ual0104', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station11:AttachBoneTo(0, self, 'Right_Attachpoint06')
		AAirUnit.OnStopBeingBuilt(self,builder,layer)
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

TypeClass = UAA0104b