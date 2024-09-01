#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0303/UEL0303_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TerranWeaponFile = import('/lua/terranweapons.lua')
local TWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local TDFHeavyPlasmaCannonWeapon = TerranWeaponFile.TDFHeavyPlasmaCannonWeapon
local TIFArtilleryWeapon = TerranWeaponFile.TIFArtilleryWeapon
local TDFGaussCannonWeapon = TerranWeaponFile.TDFGaussCannonWeapon
local TIFCruiseMissileUnpackingLauncher = TerranWeaponFile.TIFCruiseMissileUnpackingLauncher

CSKTL0400 = Class(TWalkingLandUnit) {

    Weapons = {
        HeavyPlasma01 = Class(TDFHeavyPlasmaCannonWeapon) {
            DisabledFiringBones = {
                'Torso', 'L_Arm', 'L_Arm_B01', 'L_Arm_B02', 'L_Arm_B03',
                'R_Arm', 'L_Arm_B01', 'L_Arm_B02', 'L_Arm_B03',
            },
        },
		ChestArt = Class(TIFArtilleryWeapon) {
        },
		BackArt = Class(TIFArtilleryWeapon) {
            FxMuzzleFlashScale = 3,
        },
		BackArt2 = Class(TIFArtilleryWeapon) {
            FxMuzzleFlashScale = 3,
        },
		SecTurret = Class(TDFGaussCannonWeapon) {
        },
		BackMissile = Class(TIFCruiseMissileUnpackingLauncher) 
        {
            FxMuzzleFlash = {'/effects/emitters/terran_mobile_missile_launch_01_emit.bp'},
            
            
            OnLostTarget = function(self)
                self:ForkThread( self.LostTargetThread )
            end,
            
            RackSalvoFiringState = State(TIFCruiseMissileUnpackingLauncher.RackSalvoFiringState) {
                OnLostTarget = function(self)
                    self:ForkThread( self.LostTargetThread )
                end,            
            },            

            LostTargetThread = function(self)
                while not self.unit:IsDead() and self.unit:IsUnitState('Busy') do
                    WaitSeconds(2)
                end

                if self.unit:IsDead() then
                    return
                end
                
                local bp = self:GetBlueprint()

                if bp.WeaponUnpacks then
                    ChangeState(self, self.WeaponPackingState)
                else
                    ChangeState(self, self.IdleState)
                end
            end,
        },
    },
	
	OnStopBeingBuilt = function(self, builder, layer)
        TWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetWeaponEnabledByLabel('BackArt', false)
		self:SetWeaponEnabledByLabel('BackArt2', false)
		self:SetWeaponEnabledByLabel('BackMissile', false)
		self.Trash:Add(CreateRotator(self, 'Spinner1', 'z', nil, 180, 0, 180))
		self.Trash:Add(CreateRotator(self, 'Spinner2', 'z', nil, -180, 0, 180))
		self:HideBone( 'R_Art_Barrel', true )
		self:HideBone( 'L_Art_Barrel', true )
		self:HideBone( 'R_ML', true )
		self:HideBone( 'L_ML', true )
		
		local RandomNumber = math.random(1, 3)
		
		if RandomNumber == 1 then
		
		elseif RandomNumber == 2 then
		self:SetWeaponEnabledByLabel('BackArt', true)
		self:SetWeaponEnabledByLabel('BackArt2', true)
		self:ShowBone( 'R_Art_Barrel', true )
		self:ShowBone( 'L_Art_Barrel', true )
		elseif RandomNumber == 3 then
		self:SetWeaponEnabledByLabel('BackMissile', true)
		self:ShowBone( 'R_ML', true )
		self:ShowBone( 'L_ML', true )
		end
		
		ForkThread( function()

		end
		)
    end,
	
	CreateEnhancement = function(self, enh)
        TWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh == 'BackArtillery' then
			self:SetWeaponEnabledByLabel('BackArt', true)
			self:SetWeaponEnabledByLabel('BackArt2', true)
		    local amt = self:GetTacticalSiloAmmoCount()
            self:RemoveTacticalSiloAmmo(amt or 0)
        elseif enh =='BackTacticalMissileLaunchers' then
			self:SetWeaponEnabledByLabel('BackArt', false)
			self:SetWeaponEnabledByLabel('BackArt2', false)
            self:SetWeaponEnabledByLabel('BackMissile', true)
        end
    end,
    
}

TypeClass = CSKTL0400