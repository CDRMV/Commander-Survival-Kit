#****************************************************************************
#**
#**  File     :  /cdimage/units/UES0202/UES0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Cruiser Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TSeaUnit = import('/lua/terranunits.lua').TSeaUnit
local WeaponFile = import('/lua/terranweapons.lua')
local TIFCruiseMissileLauncher = WeaponFile.TIFCruiseMissileLauncher

CSKTS0200 = Class(TSeaUnit) {
    DestructionTicks = 200,

    Weapons = {

        CruiseMissile = Class(TIFCruiseMissileLauncher) {
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
                    if self.CurrentRack >= 8 then
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

}

TypeClass = CSKTS0200
