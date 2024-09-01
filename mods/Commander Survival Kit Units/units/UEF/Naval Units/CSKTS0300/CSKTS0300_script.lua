#****************************************************************************
#**
#**  File     :  /cdimage/units/UES0201/UES0201_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Terran Destroyer Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TSeaUnit = import('/lua/defaultunits.lua').SeaUnit
local WeaponFile = import('/lua/terranweapons.lua')
local TDFGaussCannonWeapon = WeaponFile.TDFGaussCannonWeapon
local TANTorpedoAngler = WeaponFile.TANTorpedoAngler
local TIFSmartCharge = WeaponFile.TIFSmartCharge
local TIFCruiseMissileLauncher = WeaponFile.TIFCruiseMissileLauncher
local TAMPhalanxWeapon = WeaponFile.TAMPhalanxWeapon
local TSAMLauncher = WeaponFile.TSAMLauncher
local EffectTemplate = import('/lua/EffectTemplates.lua')

CSKTS0300 = Class(TSeaUnit) {
    DestructionTicks = 200,

    Weapons = {
		AAMissileLauncher = Class(TSAMLauncher) {
            FxMuzzleFlash = EffectTemplate.TAAMissileLaunchNoBackSmoke,
        },
        FrontTurret01 = Class(TDFGaussCannonWeapon) {},
        BackTurret01 = Class(TDFGaussCannonWeapon) {},
        Torpedo01 = Class(TANTorpedoAngler) {},
        AntiTorpedo = Class(TIFSmartCharge) {},
		PhalanxGun01 = Class(TAMPhalanxWeapon) {
            PlayFxWeaponUnpackSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'TMD_Barrel', 'z', nil, 270, 180, 60)
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
                    self.SpinManip = CreateRotator(self.unit, 'TMD2_Barrel', 'z', nil, 270, 180, 60)
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
		FrontCruiseMissileBlock = Class(TIFCruiseMissileLauncher) {
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
			BackCruiseMissileBlock = Class(TIFCruiseMissileLauncher) {
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
                    if self.CurrentRack >= 4 then
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
		},	

	OnCreate = function(self)
		TSeaUnit.OnCreate(self)
		self:DisableUnitIntel('Cloak')
		self:DisableUnitIntel('CloakField')
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
		TSeaUnit.OnStopBeingBuilt(self,builder,layer)
		self:DisableUnitIntel('Cloak')
		self:DisableUnitIntel('CloakField')
    end,	
			
		OnScriptBitSet = function(self, bit)
        if bit == 1 then 
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			local location = self:GetPosition()
			self:ForkThread(function()  
			WaitSeconds(1)	
			local SmokeUnit = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(3)	
			local SmokeUnit2 = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(3)	
			local SmokeUnit3 = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(20) -- Sets the Reloadtime of the Ability
			self:AddToggleCap('RULEUTC_WeaponToggle')		
			end)			
        end
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 1 then 
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			local location = self:GetPosition()
			self:ForkThread(function()  
			WaitSeconds(1)	
			local SmokeUnit = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(3)	
			local SmokeUnit2 = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(3)	
			local SmokeUnit3 = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(20) -- Sets the Reloadtime of the Ability
			self:AddToggleCap('RULEUTC_WeaponToggle')		
			end)	
        end
    end,

}

TypeClass = CSKTS0300