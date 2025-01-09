#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0203/UAA0203_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Gunship Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/defaultunits.lua').AirUnit
local AAAZealotMissileWeapon = import('/lua/aeonweapons.lua').AAAZealotMissileWeapon
local ADFPhasonLaser = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').ADFMiniPhasonLaser
local ModWeaponsFile = import("/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua")
local ADFTeniumCannonWeapon = ModWeaponsFile.ADFTeniumCannonWeapon

CSKAA0400 = Class(AAirUnit) {
    Weapons = {
		MainGun = Class(ADFTeniumCannonWeapon) {},
		AntiAirMissiles = Class(AAAZealotMissileWeapon) {},
        EyeWeapon = Class(ADFPhasonLaser) {
		
		        PlayFxWeaponUnpackSequence = function(self)
					self:ForkThread(
					function()
                    if self.unit.Spinner3 then 
					self.unit.Spinner3:Destroy()
                    end
					if self.unit.Spinner4 then 
					self.unit.Spinner4:Destroy()
                    end
					if self.unit.Spinner5 then 
					self.unit.Spinner5:Destroy()
                    end
					if self.unit.Spinner6 then 
					self.unit.Spinner6:Destroy()
                    end
					WaitSeconds(5)
					self.unit:SetWeaponEnabledByLabel('MainGun', true)
					self.unit:GetWeaponByLabel'MainGun':FireWeapon()
					WaitSeconds(1)
					IssueClearCommands({self.unit})
					self.unit:SetImmobile(false)
					end)
                    ADFPhasonLaser.PlayFxWeaponUnpackSequence(self)
                end,

                PlayFxWeaponPackSequence = function(self)
					self.unit:SetWeaponEnabledByLabel('MainGun', false)
					self.unit.Spinner3 = CreateRotator(self.unit, 'Spinner05', 'y', nil, 0, 60, 360):SetTargetSpeed(90)
					self.unit.Spinner4 = CreateRotator(self.unit, 'Spinner06', 'y', nil, 0, 60, -360):SetTargetSpeed(-90)
					self.unit.Spinner5 = CreateRotator(self.unit, 'Spinner07', 'x', nil, 0, 60, 360):SetTargetSpeed(90)
					self.unit.Spinner6 = CreateRotator(self.unit, 'Spinner08', 'x', nil, 0, 60, -360):SetTargetSpeed(-90)
                    ADFPhasonLaser.PlayFxWeaponPackSequence(self)
                end,
		
		},
    },
	
	BuildAttachBone = 'CSKAA0400',
	
	OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetWeaponEnabledByLabel('MainGun', false)
        self.Spinner1 = CreateRotator(self, 'CSKAA0400', 'y', nil, 0, 60, 360):SetTargetSpeed(0)
		self.Spinner2 = CreateRotator(self, 'Spinner', 'y', nil, 0, 60, 360):SetTargetSpeed(0)
		self.Spinner3 = CreateRotator(self, 'Spinner05', 'y', nil, 0, 60, 360):SetTargetSpeed(90)
		self.Spinner4 = CreateRotator(self, 'Spinner06', 'y', nil, 0, 60, -360):SetTargetSpeed(-90)
		self.Spinner5 = CreateRotator(self, 'Spinner07', 'x', nil, 0, 60, 360):SetTargetSpeed(90)
		self.Spinner6 = CreateRotator(self, 'Spinner08', 'x', nil, 0, 60, -360):SetTargetSpeed(-90)
		ChangeState(self, self.IdleState)
    end,
	
	OnMotionHorzEventChange = function(self, new, old)

        if old == 'Stopped' then
			self.Spinner1:SetTargetSpeed(0)
			self.Spinner2:SetTargetSpeed(0)
        end

        if new == 'Stopping' then
			self.Spinner1:SetTargetSpeed(2)
			self.Spinner2:SetTargetSpeed(5)
        end

    end,
	


    OnFailedToBuild = function(self)
        AAirUnit.OnFailedToBuild(self)
        ChangeState(self, self.IdleState)
    end,

    IdleState = State {
        Main = function(self)
            self:DetachAll(self.BuildAttachBone)
            self:SetBusy(false)
        end,

        OnStartBuild = function(self, unitBuilding, order)
            AAirUnit.OnStartBuild(self, unitBuilding, order)
            self.UnitBeingBuilt = unitBuilding
            ChangeState(self, self.BuildingState)
        end,
    },

    BuildingState = State {
        Main = function(self)
            local unitBuilding = self.UnitBeingBuilt
            self:SetBusy(true)
            local bone = self.BuildAttachBone
            self:DetachAll(bone)
            unitBuilding:HideBone(0, true)
            self.UnitDoneBeingBuilt = false
        end,

        OnStopBuild = function(self, unitBeingBuilt)
            AAirUnit.OnStopBuild(self, unitBeingBuilt)
            ChangeState(self, self.FinishedBuildingState)
        end,
    },

    FinishedBuildingState = State {
        Main = function(self)
            self:SetBusy(true)
            local unitBuilding = self.UnitBeingBuilt
            unitBuilding:DetachFrom(true)
            self:DetachAll(self.BuildAttachBone)
            if self:TransportHasAvailableStorage() then
                self:AddUnitToStorage(unitBuilding)
            else
                local worldPos = self:CalculateWorldPositionFromRelative({0, 0, -20})
                IssueMoveOffFactory({unitBuilding}, worldPos)
                unitBuilding:ShowBone(0,true)
            end
            self:SetBusy(false)
            self:RequestRefreshUI()
            ChangeState(self, self.IdleState)
        end,
    },
	
}

TypeClass = CSKAA0400