#****************************************************************************
#**
#**  File     :  /cdimage/units/URA0107/URA0107_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Cybran T1 Air Transport Script
#**
#**  Copyright � 2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CAirUnit = import('/lua/defaultunits.lua').AirUnit
local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')

URA0107b = Class(CAirUnit) {
    Weapons = {
    },

    AirDestructionEffectBones = { 'Left_Exhaust', 'Right_Exhaust', 'Char04', 'Char03', 'Char02', 'Char01',
                                  'Front_Left_Leg03_B02', 'Front_Right_Leg03_B02', 'Front_Left_Leg01_B02', 'Front_Right_Leg01_B02',
                                  'Right_AttachPoint01', 'Right_AttachPoint02', 'Right_AttachPoint03', 'Right_AttachPoint04',
                                  'Left_AttachPoint01', 'Left_AttachPoint02', 'Left_AttachPoint03', 'Left_AttachPoint04', },

    BeamExhaustIdle = '/effects/emitters/missile_exhaust_fire_beam_05_emit.bp',
    BeamExhaustCruise = '/effects/emitters/missile_exhaust_fire_beam_04_emit.bp',

    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
		
		LOG('*ATTACHING UNITS TO TRANS!!')
        local position = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Station08 = CreateUnitHPR('url0106', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station08:AttachBoneTo('Turret', self, 'Attachpoint_sml_01')
		self.Station09 = CreateUnitHPR('url0106', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station09:AttachBoneTo('Turret', self, 'Attachpoint_sml_02')
		self.Station10 = CreateUnitHPR('url0107', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo('AttachPoint', self, 'Attachpoint_sml_03')
		self.Station08 = CreateUnitHPR('url0107', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station08:AttachBoneTo('AttachPoint', self, 'Attachpoint_sml_04')
		self.Station09 = CreateUnitHPR('url0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station09:AttachBoneTo('AttachPoint', self, 'Attachpoint_sml_05')
		self.Station10 = CreateUnitHPR('url0104', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo('AttachPoint', self, 'Attachpoint_sml_06')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
        self.AnimManip = CreateAnimator(self)
        self.Trash:Add(self.AnimManip)
        self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTakeOff, false):SetRate(1)
    end,

    # When one of our attached units gets killed, detach it
    OnAttachedKilled = function(self, attached)
        attached:DetachFrom()
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        CAirUnit.OnKilled(self, instigator, type, overkillRatio)
        # TransportDetachAllUnits takes 1 bool parameter. If true, randomly destroys some of the transported
        # units, otherwise successfully detaches all.
        self:TransportDetachAllUnits(true)
    end,

    OnMotionVertEventChange = function(self, new, old)
        #LOG( 'OnMotionVertEventChange, new = ', new, ', old = ', old )
        CAirUnit.OnMotionVertEventChange(self, new, old)
        #Aborting a landing
        if ((new == 'Top' or new == 'Up') and old == 'Down') then
            self.AnimManip:SetRate(-1)
        elseif (new == 'Down') then
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationLand, false):SetRate(1.5)
#NOTE: We need to add funtionality to fit this guy on the platform            
#        elseif (new == 'Bottom') then
#            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationIdle, true):SetRate(1)
        elseif (new == 'Up') then
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTakeOff, false):SetRate(1)
        end
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

TypeClass = URA0107b