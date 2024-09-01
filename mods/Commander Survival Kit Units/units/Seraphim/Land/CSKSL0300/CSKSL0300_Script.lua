#****************************************************************************
#**
#**  File     :  /units/XSL0202/XSL0202_script.lua
#**
#**  Summary  :  Seraphim Heavy Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local SDFAireauBolterWeapon = import('/lua/seraphimweapons.lua').SDFAireauBolterWeapon02
local SLaanseMissileWeapon = import('/lua/seraphimweapons.lua').SLaanseMissileWeapon

CSKSL0300 = Class(SWalkingLandUnit) {
    Weapons = {
        MainGun = Class(SDFAireauBolterWeapon) {},
		MissileRack = Class(SLaanseMissileWeapon) {
            OnLostTarget = function(self)
                self:ForkThread( self.LostTargetThread )
            end,
            
            RackSalvoFiringState = State(SLaanseMissileWeapon.RackSalvoFiringState) {
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
        }
    },
}
TypeClass = CSKSL0300