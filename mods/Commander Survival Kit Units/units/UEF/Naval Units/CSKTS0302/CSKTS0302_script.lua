#****************************************************************************
#** 
#**  Author(s):  CDRMV
#**
#**  Summary  :  UEF Aircraft Carrier Script
#**
#**  Copyright © 2023 Commander Survival Kit
#****************************************************************************

local EffectTemplate = import('/lua/EffectTemplates.lua')
local TSeaUnit = import('/lua/defaultunits.lua').SeaUnit
local WeaponFile = import('/lua/terranweapons.lua')
local TIFCruiseMissileLauncher = WeaponFile.TIFCruiseMissileLauncher
local TAMPhalanxWeapon = WeaponFile.TAMPhalanxWeapon
local TSAMLauncher = WeaponFile.TSAMLauncher
local loading = false

CSKTS0302 = Class(TSeaUnit) {

    Weapons = {

	    AAMissileLauncher = Class(TSAMLauncher) {
            FxMuzzleFlash = EffectTemplate.TAAMissileLaunchNoBackSmoke,
        },
		
		CruiseMissileLauncher1 = Class(TIFCruiseMissileLauncher) {
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
		
		CruiseMissileLauncher2 = Class(TIFCruiseMissileLauncher) {
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

    BuildAttachBone = 'Attachpoint',



    OnStopBeingBuilt = function(self,builder,layer)
        TSeaUnit.OnStopBeingBuilt(self,builder,layer)
		self.Plane01 = import('/lua/sim/Entity.lua').Entity()
		PlaneMesh1 = '/mods/Commander Survival Kit Units/Decorations/Plane02_mesh',
        self.Plane01:AttachBoneTo( -1, self, 'AttachPoint01' )
        self.Plane01:SetMesh(PlaneMesh1)
        self.Plane01:SetDrawScale(0.060)
        self.Plane01:SetVizToAllies('Intel')
        self.Plane01:SetVizToNeutrals('Intel')
        self.Plane01:SetVizToEnemies('Intel')
		
		self.Plane02 = import('/lua/sim/Entity.lua').Entity()
		PlaneMesh2 = '/mods/Commander Survival Kit Units/Decorations/Plane01_mesh',
        self.Plane02:AttachBoneTo( -1, self, 'AttachPoint02' )
        self.Plane02:SetMesh(PlaneMesh2)
        self.Plane02:SetDrawScale(0.040)
        self.Plane02:SetVizToAllies('Intel')
        self.Plane02:SetVizToNeutrals('Intel')
        self.Plane02:SetVizToEnemies('Intel')
		
		self.Plane03= import('/lua/sim/Entity.lua').Entity()
		PlaneMesh3 = '/mods/Commander Survival Kit Units/Decorations/Plane02_mesh',
        self.Plane03:AttachBoneTo( -1, self, 'AttachPoint03' )
        self.Plane03:SetMesh(PlaneMesh3)
        self.Plane03:SetDrawScale(0.060)
        self.Plane03:SetVizToAllies('Intel')
        self.Plane03:SetVizToNeutrals('Intel')
        self.Plane03:SetVizToEnemies('Intel')
        ChangeState(self, self.IdleState)
		
		self.Plane04 = import('/lua/sim/Entity.lua').Entity()
		PlaneMesh4 = '/mods/Commander Survival Kit Units/Decorations/Plane02_mesh',
        self.Plane04:AttachBoneTo( -1, self, 'AttachPoint04' )
        self.Plane04:SetMesh(PlaneMesh4)
        self.Plane04:SetDrawScale(0.060)
        self.Plane04:SetVizToAllies('Intel')
        self.Plane04:SetVizToNeutrals('Intel')
        self.Plane04:SetVizToEnemies('Intel')
		
		self.Plane05 = import('/lua/sim/Entity.lua').Entity()
		PlaneMesh5 = '/mods/Commander Survival Kit Units/Decorations/Plane01_mesh',
        self.Plane05:AttachBoneTo( -1, self, 'AttachPoint05' )
        self.Plane05:SetMesh(PlaneMesh5)
        self.Plane05:SetDrawScale(0.040)
        self.Plane05:SetVizToAllies('Intel')
        self.Plane05:SetVizToNeutrals('Intel')
        self.Plane05:SetVizToEnemies('Intel')
		
		self.Engi01 = import('/lua/sim/Entity.lua').Entity()
		EngiMesh1 = '/mods/Commander Survival Kit Units/Decorations/Engi_mesh',
        self.Engi01:AttachBoneTo( -1, self, 'AttachPoint06' )
        self.Engi01:SetMesh(EngiMesh1)
        self.Engi01:SetDrawScale(0.040)
        self.Engi01:SetVizToAllies('Intel')
        self.Engi01:SetVizToNeutrals('Intel')
        self.Engi01:SetVizToEnemies('Intel')
		
		self.Plane06 = import('/lua/sim/Entity.lua').Entity()
		PlaneMesh6 = '/mods/Commander Survival Kit Units/Decorations/Plane03_mesh',
        self.Plane06:AttachBoneTo( -1, self, 'AttachPoint07' )
        self.Plane06:SetMesh(PlaneMesh6)
        self.Plane06:SetDrawScale(0.030)
        self.Plane06:SetVizToAllies('Intel')
        self.Plane06:SetVizToNeutrals('Intel')
        self.Plane06:SetVizToEnemies('Intel')
		
		self.Plane08 = import('/lua/sim/Entity.lua').Entity()
		PlaneMesh8 = '/mods/Commander Survival Kit Units/Decorations/Plane03_mesh',
        self.Plane08:AttachBoneTo( -1, self, 'AttachPoint08' )
        self.Plane08:SetMesh(PlaneMesh8)
        self.Plane08:SetDrawScale(0.030)
        self.Plane08:SetVizToAllies('Intel')
        self.Plane08:SetVizToNeutrals('Intel')
        self.Plane08:SetVizToEnemies('Intel')
		
		self.Plane09 = import('/lua/sim/Entity.lua').Entity()
		PlaneMesh9 = '/mods/Commander Survival Kit Units/Decorations/Plane02_mesh',
        self.Plane09:AttachBoneTo( -1, self, 'AttachPoint10' )
        self.Plane09:SetMesh(PlaneMesh9)
        self.Plane09:SetDrawScale(0.060)
        self.Plane09:SetVizToAllies('Intel')
        self.Plane09:SetVizToNeutrals('Intel')
        self.Plane09:SetVizToEnemies('Intel')
		
		self.Plane10 = import('/lua/sim/Entity.lua').Entity()
		PlaneMesh10 = '/mods/Commander Survival Kit Units/Decorations/Plane01_mesh',
        self.Plane10:AttachBoneTo( -1, self, 'AttachPoint09' )
        self.Plane10:SetMesh(PlaneMesh10)
        self.Plane10:SetDrawScale(0.040)
        self.Plane10:SetVizToAllies('Intel')
        self.Plane10:SetVizToNeutrals('Intel')
        self.Plane10:SetVizToEnemies('Intel')
		
    end,

    OnFailedToBuild = function(self)
        TSeaUnit.OnFailedToBuild(self)
        ChangeState(self, self.IdleState)
    end,

    IdleState = State {
        Main = function(self)
            self:DetachAll(self.BuildAttachBone)
            self:SetBusy(false)
        end,

        OnStartBuild = function(self, unitBuilding, order)
            TSeaUnit.OnStartBuild(self, unitBuilding, order)
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
            TSeaUnit.OnStopBuild(self, unitBeingBuilt)
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

TypeClass = CSKTS0302

