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
        },
		MissileRack2 = Class(SLaanseMissileWeapon) {
		
			OnWeaponFired = function(self)
				self:ForkThread(function()
                self.unit:RemoveTacticalSiloAmmo(2)
				WaitSeconds(8)
				if self.unit:GetTacticalSiloAmmoCount() == 0 then
				self.unit:GiveTacticalSiloAmmo(2)
				end
				end)
            end,
			
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
	
	OnStopBeingBuilt = function(self,builder,layer)
        SWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		local wep1 = self:GetWeaponByLabel('MissileRack')
		wep1:SetWeaponEnabled(true)	
		local wep2 = self:GetWeaponByLabel('MissileRack2')
		wep2:SetWeaponEnabled(false)
		self:SetAutoMode(true)
    end,
	
	OnScriptBitSet = function(self, bit)
        SWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self:RemoveCommandCap('RULEUCC_SiloBuildTactical')
		self:RemoveCommandCap('RULEUCC_Tactical')
		local wep3 = self:GetWeaponByLabel('MissileRack')
		wep3:SetWeaponEnabled(false)
		local wep4 = self:GetWeaponByLabel('MissileRack2')
		wep4:SetWeaponEnabled(true)
		end
    end,

    OnScriptBitClear = function(self, bit)
        SWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:AddCommandCap('RULEUCC_SiloBuildTactical')
		self:AddCommandCap('RULEUCC_Tactical')
		local wep3 = self:GetWeaponByLabel('MissileRack')
		wep3:SetWeaponEnabled(true)
		local wep4 = self:GetWeaponByLabel('MissileRack2')
		wep4:SetWeaponEnabled(false)
		end
    end,
}
TypeClass = CSKSL0300