#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0202/URL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/defaultunits.lua').MobileUnit
local ModWeaponsFile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua')
local CDFLaserIridiumWeapon = ModWeaponsFile.CDFLaserIridiumWeapon
local DummyTurretWeapon = ModWeaponsFile.DummyTurretWeapon
local CAMZapperWeapon = import('/lua/cybranweapons.lua').CAMZapperWeapon
local CollisionBeamFile = import('/lua/defaultcollisionbeams.lua')
local WeaponFile = import('/lua/sim/DefaultWeapons.lua')
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon
CSKCL0316 = Class(CLandUnit) {

    SphereEffectIdleMesh = '/effects/entities/cybranphalanxsphere01/cybranphalanxsphere01_mesh',
    SphereEffectActiveMesh = '/effects/entities/cybranphalanxsphere01/cybranphalanxsphere02_mesh',
    SphereEffectBp = '/effects/emitters/zapper_electricity_01_emit.bp',
    SphereEffectBone = 'Turret_Muzzle',

    Weapons = {
	  Dummy = Class(DummyTurretWeapon) {
	  FxMuzzleFlash = {'/mods/Commander Survival Kit Units/effects/emitters/empty_flash_01_emit.bp',},
	  },
	  Turret01 = Class(CAMZapperWeapon) {
	  BeamType = CollisionBeamFile.ZapperCollisionBeam,
    FxMuzzleFlash = {'/effects/emitters/cannon_muzzle_flash_01_emit.bp',},

    
    OnCreate = function(self)
        DefaultBeamWeapon.OnCreate(self)

        self.SphereEffectEntity = import('/lua/sim/Entity.lua').Entity()
        self.SphereEffectEntity:AttachBoneTo( -1, self.unit,self:GetBlueprint().RackBones[1].MuzzleBones[1] )
        self.SphereEffectEntity:SetMesh(self.SphereEffectIdleMesh)
        self.SphereEffectEntity:SetDrawScale(0.5)
        self.SphereEffectEntity:SetVizToAllies('Intel')
        self.SphereEffectEntity:SetVizToNeutrals('Intel')
        self.SphereEffectEntity:SetVizToEnemies('Intel')
        
        local emit = CreateAttachedEmitter( self.unit, self:GetBlueprint().RackBones[1].MuzzleBones[1], self.unit:GetArmy(), self.SphereEffectBp )

        self.unit.Trash:Add(self.SphereEffectEntity)
        self.unit.Trash:Add(emit)
    end,

    IdleState = State (DefaultBeamWeapon.IdleState) {
        Main = function(self)
            DefaultBeamWeapon.IdleState.Main(self)
        end,

        OnGotTarget = function(self)
            DefaultBeamWeapon.IdleState.OnGotTarget(self)
            self.SphereEffectEntity:SetMesh(self.SphereEffectActiveMesh)
        end,
    },

    OnLostTarget = function(self)
        DefaultBeamWeapon.OnLostTarget(self)
        self.SphereEffectEntity:SetMesh(self.SphereEffectIdleMesh)
    end,    
	  
	  },
	}, 

	OnStopBeingBuilt = function(self,builder,layer)
        CLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:HideBone('Turret_Muzzle', false)
    end,
	
}

TypeClass = CSKCL0316