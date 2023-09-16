#****************************************************************************
#**
#**  File     :  /cdimage/units/UES0201/UES0201_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Terran Destroyer Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TSeaUnit = import('/lua/defaultunits.lua').SeaUnit
local WeaponFile = import('/lua/terranweapons.lua')
local TDFShipGaussCannonWeapon = WeaponFile.TDFShipGaussCannonWeapon
local TIFCruiseMissileLauncher = WeaponFile.TIFCruiseMissileLauncher
local TAMPhalanxWeapon = WeaponFile.TAMPhalanxWeapon
local TSAMLauncher = WeaponFile.TSAMLauncher

CSKTS0301 = Class(TSeaUnit) {
    DestructionTicks = 200,

    Weapons = {
	    AAMissileLauncher = Class(TSAMLauncher) {
            FxMuzzleFlash = EffectTemplate.TAAMissileLaunchNoBackSmoke,
        },
        MainGun = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.60,
		},
		RSecondary1 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		RSecondary2 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		RSecondary3 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		RSecondary4 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		RSecondary5 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		LSecondary1 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		LSecondary1 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		LSecondary2 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		LSecondary3 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		LSecondary4 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		LSecondary5 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		RSecondaryAA1 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		RSecondaryAA2 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		RSecondaryAA3 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		RSecondaryAA4 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		RSecondaryAA5 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		LSecondaryAA1 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		LSecondaryAA2 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		LSecondaryAA3 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		LSecondaryAA4 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		LSecondaryAA5 = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		CruiseMissileLauncher = Class(TIFCruiseMissileLauncher) {
                CurrentRack = 1,
                
                #taken out because all this waiting causes broken rate of fire clock issues
                --PlayFxMuzzleSequence = function(self, muzzle)
                    --local bp = self:GetBlueprint()
                    --self.Rotator = CreateRotator(self.unit, bp.RackBones[self.CurrentRack].RackBone, 'y', nil, 90, 90, 90)
                    --muzzle = bp.RackBones[self.CurrentRack].MuzzleBones[1]
                    --self.Rotator:SetGoal(90)
                    --TIFCruiseMissileLauncher.PlayFxMuzzleSequence(self, muzzle)
                    --WaitFor(self.Rotator)
                    --WaitSeconds(1)
                --end,
                
                CreateProjectileAtMuzzle = function(self, muzzle)
                    muzzle = self:GetBlueprint().RackBones[self.CurrentRack].MuzzleBones[1]
                    if self.CurrentRack >= 6 then
                        self.CurrentRack = 1
                    else
                        self.CurrentRack = self.CurrentRack + 1
                    end
                    TIFCruiseMissileLauncher.CreateProjectileAtMuzzle(self, muzzle)
                end,
                
                #taken out because all this waiting causes broken rate of fire clock issues
                --PlayFxRackReloadSequence = function(self)
                    --WaitSeconds(1)
                    --self.Rotator:SetGoal(0)
                    --WaitFor(self.Rotator)
                    --self.Rotator:Destroy()
                    --self.Rotator = nil
                --end,
            },
		PhalanxGun01 = Class(TAMPhalanxWeapon) {
            PlayFxWeaponUnpackSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'L_TMD01_Barrel', 'z', nil, 270, 180, 60)
                    self.SpinManip:SetPrecedence(10)
                    self.unit.Trash:Add(self.SpinManip)
                end
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(270)
                end
                TAMPhalanxWeapon.PlayFxWeaponUnpackSequence(self)
            end,

            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                TAMPhalanxWeapon.PlayFxWeaponPackSequence(self)
            end,
        },	
		PhalanxGun02 = Class(TAMPhalanxWeapon) {
            PlayFxWeaponUnpackSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'L_TMD02_Barrel', 'z', nil, 270, 180, 60)
                    self.SpinManip:SetPrecedence(10)
                    self.unit.Trash:Add(self.SpinManip)
                end
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(270)
                end
                TAMPhalanxWeapon.PlayFxWeaponUnpackSequence(self)
            end,

            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                TAMPhalanxWeapon.PlayFxWeaponPackSequence(self)
            end,
        },
		PhalanxGun03 = Class(TAMPhalanxWeapon) {
            PlayFxWeaponUnpackSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'R_TMD01_Barrel', 'z', nil, 270, 180, 60)
                    self.SpinManip:SetPrecedence(10)
                    self.unit.Trash:Add(self.SpinManip)
                end
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(270)
                end
                TAMPhalanxWeapon.PlayFxWeaponUnpackSequence(self)
            end,

            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                TAMPhalanxWeapon.PlayFxWeaponPackSequence(self)
            end,
        },
		PhalanxGun04 = Class(TAMPhalanxWeapon) {
            PlayFxWeaponUnpackSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'R_TMD02_Barrel', 'z', nil, 270, 180, 60)
                    self.SpinManip:SetPrecedence(10)
                    self.unit.Trash:Add(self.SpinManip)
                end
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(270)
                end
                TAMPhalanxWeapon.PlayFxWeaponUnpackSequence(self)
            end,

            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                TAMPhalanxWeapon.PlayFxWeaponPackSequence(self)
            end,
        },			
    },
	
	OnCreate = function(self)
        TSeaUnit.OnCreate(self)
        self:SetWeaponEnabledByLabel('RSecondary1', true)
		self:SetWeaponEnabledByLabel('RSecondary2', true)
		self:SetWeaponEnabledByLabel('RSecondary3', true)
		self:SetWeaponEnabledByLabel('RSecondary4', true)
		self:SetWeaponEnabledByLabel('RSecondary5', true)
		self:SetWeaponEnabledByLabel('LSecondary1', true)
		self:SetWeaponEnabledByLabel('LSecondary2', true)
		self:SetWeaponEnabledByLabel('LSecondary3', true)
		self:SetWeaponEnabledByLabel('LSecondary4', true)
		self:SetWeaponEnabledByLabel('LSecondary5', true)
		self:SetWeaponEnabledByLabel('RSecondaryAA1', false)
		self:SetWeaponEnabledByLabel('RSecondaryAA2', false)
		self:SetWeaponEnabledByLabel('RSecondaryAA3', false)
		self:SetWeaponEnabledByLabel('RSecondaryAA4', false)
		self:SetWeaponEnabledByLabel('RSecondaryAA5', false)
		self:SetWeaponEnabledByLabel('LSecondaryAA1', false)
		self:SetWeaponEnabledByLabel('LSecondaryAA2', false)
		self:SetWeaponEnabledByLabel('LSecondaryAA3', false)
		self:SetWeaponEnabledByLabel('LSecondaryAA4', false)
		self:SetWeaponEnabledByLabel('LSecondaryAA5', false)
    end,
    
    OnScriptBitSet = function(self, bit)
        TSeaUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self:SetWeaponEnabledByLabel('RSecondary1', false)
		self:SetWeaponEnabledByLabel('RSecondary2', false)
		self:SetWeaponEnabledByLabel('RSecondary3', false)
		self:SetWeaponEnabledByLabel('RSecondary4', false)
		self:SetWeaponEnabledByLabel('RSecondary5', false)
		self:SetWeaponEnabledByLabel('LSecondary1', false)
		self:SetWeaponEnabledByLabel('LSecondary2', false)
		self:SetWeaponEnabledByLabel('LSecondary3', false)
		self:SetWeaponEnabledByLabel('LSecondary4', false)
		self:SetWeaponEnabledByLabel('LSecondary5', false)
		self:SetWeaponEnabledByLabel('RSecondaryAA1', true)
		self:SetWeaponEnabledByLabel('RSecondaryAA2', true)
		self:SetWeaponEnabledByLabel('RSecondaryAA3', true)
		self:SetWeaponEnabledByLabel('RSecondaryAA4', true)
		self:SetWeaponEnabledByLabel('RSecondaryAA5', true)
		self:SetWeaponEnabledByLabel('LSecondaryAA1', true)
		self:SetWeaponEnabledByLabel('LSecondaryAA2', true)
		self:SetWeaponEnabledByLabel('LSecondaryAA3', true)
		self:SetWeaponEnabledByLabel('LSecondaryAA4', true)
		self:SetWeaponEnabledByLabel('LSecondaryAA5', true)
        self:GetWeaponManipulatorByLabel('RSecondary1'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('RSecondaryAA1'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('RSecondary2'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('RSecondaryAA2'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('RSecondary3'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('RSecondaryAA3'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('RSecondary4'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('RSecondaryAA4'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('RSecondary5'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('RSecondaryAA5'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('LSecondary1'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('LSecondaryAA1'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('LSecondary2'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('LSecondaryAA2'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('LSecondary3'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('LSecondaryAA3'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('LSecondary4'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('LSecondaryAA4'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('LSecondary5'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('LSecondaryAA5'):GetHeadingPitch() )
        end
    end,

    OnScriptBitClear = function(self, bit)
        TSeaUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:SetWeaponEnabledByLabel('RSecondary1', true)
		self:SetWeaponEnabledByLabel('RSecondary2', true)
		self:SetWeaponEnabledByLabel('RSecondary3', true)
		self:SetWeaponEnabledByLabel('RSecondary4', true)
		self:SetWeaponEnabledByLabel('RSecondary5', true)
		self:SetWeaponEnabledByLabel('LSecondary1', true)
		self:SetWeaponEnabledByLabel('LSecondary2', true)
		self:SetWeaponEnabledByLabel('LSecondary3', true)
		self:SetWeaponEnabledByLabel('LSecondary4', true)
		self:SetWeaponEnabledByLabel('LSecondary5', true)
		self:SetWeaponEnabledByLabel('RSecondaryAA1', false)
		self:SetWeaponEnabledByLabel('RSecondaryAA2', false)
		self:SetWeaponEnabledByLabel('RSecondaryAA3', false)
		self:SetWeaponEnabledByLabel('RSecondaryAA4', false)
		self:SetWeaponEnabledByLabel('RSecondaryAA5', false)
		self:SetWeaponEnabledByLabel('LSecondaryAA1', false)
		self:SetWeaponEnabledByLabel('LSecondaryAA2', false)
		self:SetWeaponEnabledByLabel('LSecondaryAA3', false)
		self:SetWeaponEnabledByLabel('LSecondaryAA4', false)
		self:SetWeaponEnabledByLabel('LSecondaryAA5', false)
        self:GetWeaponManipulatorByLabel('RSecondaryAA1'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('RSecondary1'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('RSecondaryAA2'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('RSecondary2'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('RSecondaryAA3'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('RSecondary3'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('RSecondaryAA4'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('RSecondary4'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('RSecondaryAA5'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('RSecondary5'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('LSecondaryAA1'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('LSecondary1'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('LSecondaryAA2'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('LSecondary2'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('LSecondaryAA3'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('LSecondary3'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('LSecondaryAA4'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('LSecondary4'):GetHeadingPitch() )
		self:GetWeaponManipulatorByLabel('LSecondaryAA5'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('LSecondary5'):GetHeadingPitch() )
        end
    end,
	
}

TypeClass = CSKTS0301