#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2101/UEB2101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Terran Light Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local utilities = import('/lua/utilities.lua')
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone
local TIFHighBallisticMortarWeapon = import('/lua/terranweapons.lua').TIFHighBallisticMortarWeapon

UEBMD0100 = Class(TStructureUnit) {
    Weapons = {
	    Flamethrower = Class(TDFMachineGunWeapon) {
        },
        MG = Class(TDFRiotWeapon) {},
		MissileLauncher = Class(TSAMLauncher) {},
		Cannon = Class(TDFGaussCannonWeapon) {

		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'AC_Muzzle' then
		CreateAttachedEmitter(self.unit, 'AC_Effect', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		},
		GatlingCannon = Class(TDFMachineGunWeapon) 
        {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFMachineGunWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'Gatling_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TDFMachineGunWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFMachineGunWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
		Mortar = Class(TIFHighBallisticMortarWeapon) {
                
                CreateProjectileAtMuzzle = function(self, muzzle)
                    local proj = TIFHighBallisticMortarWeapon.CreateProjectileAtMuzzle(self, muzzle)
                    local data = {
                        Radius = self:GetBlueprint().CameraVisionRadius or 5,
                        Lifetime = self:GetBlueprint().CameraLifetime or 5,
                        Army = self.unit:GetArmy(),
                    }
                    if proj and not proj:BeenDestroyed() then
                        proj:PassData(data)
                    end
                end,
            },
    },
	
	OnCreate = function(self)
		self:HideBone( 0, true )
		self:ShowBone( 'CallBeacon', true )
        TStructureUnit.OnCreate(self)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
			ForkThread( function()
		local army = self:GetArmy()
        local position = self:GetPosition()
		local orientation = RandomFloat(0,2*math.pi)
		self.Beam = CreateBeamEmitterOnEntity(self, 'CallBeacon_Muzzle', army, '/mods/Commander Survival Kit Units/effects/emitters/beacon_beam_01_emit.bp')
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationArrival, false):SetRate(2)	
		self.ArmSlider1 = CreateSlider(self, 'Pod')
        self.Trash:Add(self.ArmSlider1)
		self.ArmSlider1:SetGoal(0, 1000, 0)
		self.ArmSlider1:SetSpeed(1000)
		self:HideBone( 'Pod', true )
        self:SetUnSelectable(true)	
		WaitSeconds(1)			
		self.ArmSlider1 = CreateSlider(self, 'Pod')
		self.Trash:Add(self.ArmSlider1)        
		self.ArmSlider1:SetGoal(0, -1000, 0)
		self.ArmSlider1:SetSpeed(100)
		self.Dummy = import('/lua/sim/Entity.lua').Entity()
		Dummy = '/mods/Commander Survival Kit Units/projectiles/Asteroid/Mesh/Asteroid_mesh',
        self.Dummy:AttachBoneTo( -1, self, 'Effect' )
        self.Dummy:SetMesh(Dummy)
        self.Dummy:SetDrawScale(0.000)
        self.Dummy:SetVizToAllies('Intel')
        self.Dummy:SetVizToNeutrals('Intel')
        self.Dummy:SetVizToEnemies('Intel')
		self.ArrivalEffect1 = CreateAttachedEmitter(self.Dummy,0,self:GetArmy(), '/effects/emitters/nuke_munition_launch_trail_04_emit.bp'):ScaleEmitter(4):OffsetEmitter(0,-1,0)
		self.ArrivalEffect2 = CreateAttachedEmitter(self.Dummy,0,self:GetArmy(), '/effects/emitters/nuke_munition_launch_trail_06_emit.bp'):ScaleEmitter(4):OffsetEmitter(0,-1,0)
		self.ArrivalEffect3 = CreateAttachedEmitter(self.Dummy,0,self:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/fire_trail_08_emit.bp'):ScaleEmitter(4):OffsetEmitter(0,-1,0)
		self:ShowBone( 0, true )
		self:HideBone( 'Turret', true )
		WaitSeconds(10)
		CreateEmitterOnEntity(self,self:GetArmy(), '/effects/emitters/destruction_explosion_flash_04_emit.bp')
		CreateEmitterOnEntity(self,self:GetArmy(), '/effects/emitters/destruction_explosion_flash_05_emit.bp')
        DamageArea(self, position, 4, 10, 'Force', false, false)
        DamageArea(self, position, 4, 10, 'Fire', false, false)
        CreateDecal(position, orientation, 'Scorch_010_albedo', '', 'Albedo', 2, 2, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 2, 2, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 2, 2, 500, 600, army)
	    self.ArrivalEffect1:Destroy()
		self.ArrivalEffect2:Destroy()
		self.ArrivalEffect3:Destroy()
		self:HideBone( 'CallBeacon', true )
		self.Beam:Destroy()
		if not self.AnimationManipulator2 then
            self.AnimationManipulator2 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator2)
        end
        self.AnimationManipulator2:PlayAnim(self:GetBlueprint().Display.AnimationUnpack, false):SetRate(1)	
		self:SetUnSelectable(false)	
		self:ShowBone( 'Turret', false )
		local RandomNumber = math.random(1, 6)
		if RandomNumber == 1 then
		self:HideBone( 'Mortar_Barrel', true )
		self:HideBone( 'Gatling_Barrel', true )
		self:HideBone( 'MissileLauncher', true )
		self:HideBone( 'AC_Barrel', true )
		self:HideBone( 'Flame_Barrel', true )
		self:ShowBone( 'MG_Barrel', true )
		self:SetWeaponEnabledByLabel('MG', true)
		self:SetWeaponEnabledByLabel('MissileLauncher', false)
		self:SetWeaponEnabledByLabel('Cannon', false)
		self:SetWeaponEnabledByLabel('GatlingCannon', false)
		self:SetWeaponEnabledByLabel('Mortar', false)
		self:SetWeaponEnabledByLabel('Flamethrower', false)
		elseif RandomNumber == 2 then
		self:HideBone( 'Mortar_Barrel', true )
		self:HideBone( 'Gatling_Barrel', true )
		self:HideBone( 'MG_Barrel', true )
		self:HideBone( 'AC_Barrel', true )
		self:HideBone( 'Flame_Barrel', true )
		self:ShowBone( 'MissileLauncher', true )
		self:SetWeaponEnabledByLabel('MG', false)
		self:SetWeaponEnabledByLabel('MissileLauncher', true)
		self:SetWeaponEnabledByLabel('Cannon', false)
		self:SetWeaponEnabledByLabel('GatlingCannon', false)
		self:SetWeaponEnabledByLabel('Mortar', false)
		self:SetWeaponEnabledByLabel('Flamethrower', false)
		elseif RandomNumber == 3 then
		self:HideBone( 'Mortar_Barrel', true )
		self:HideBone( 'Gatling_Barrel', true )
		self:HideBone( 'MG_Barrel', true )
		self:ShowBone( 'AC_Barrel', true )
		self:HideBone( 'Flame_Barrel', true )
		self:HideBone( 'MissileLauncher', true )
		self:SetWeaponEnabledByLabel('MG', false)
		self:SetWeaponEnabledByLabel('MissileLauncher', false)
		self:SetWeaponEnabledByLabel('Cannon', true)
		self:SetWeaponEnabledByLabel('GatlingCannon', false)
		self:SetWeaponEnabledByLabel('Mortar', false)
		self:SetWeaponEnabledByLabel('Flamethrower', false)
		elseif RandomNumber == 4 then
		self:HideBone( 'Mortar_Barrel', true )
		self:ShowBone( 'Gatling_Barrel', true )
		self:HideBone( 'MG_Barrel', true )
		self:HideBone( 'AC_Barrel', true )
		self:HideBone( 'Flame_Barrel', true )
		self:HideBone( 'MissileLauncher', true )
		self:SetWeaponEnabledByLabel('MG', false)
		self:SetWeaponEnabledByLabel('MissileLauncher', false)
		self:SetWeaponEnabledByLabel('Cannon', false)
		self:SetWeaponEnabledByLabel('GatlingCannon', true)
		self:SetWeaponEnabledByLabel('Mortar', false)
		self:SetWeaponEnabledByLabel('Flamethrower', false)
		elseif RandomNumber == 5 then
		self:HideBone( 'Mortar_Barrel', true )
		self:HideBone( 'Gatling_Barrel', true )
		self:HideBone( 'MG_Barrel', true )
		self:HideBone( 'AC_Barrel', true )
		self:ShowBone( 'Flame_Barrel', true )
		self:HideBone( 'MissileLauncher', true )
		self:SetWeaponEnabledByLabel('MG', false)
		self:SetWeaponEnabledByLabel('MissileLauncher', false)
		self:SetWeaponEnabledByLabel('Cannon', false)
		self:SetWeaponEnabledByLabel('GatlingCannon', false)
		self:SetWeaponEnabledByLabel('Mortar', false)
		self:SetWeaponEnabledByLabel('Flamethrower', true)
		elseif RandomNumber == 6 then
		self:ShowBone( 'Mortar_Barrel', true )
		self:HideBone( 'Gatling_Barrel', true )
		self:HideBone( 'MG_Barrel', true )
		self:HideBone( 'AC_Barrel', true )
		self:HideBone( 'Flame_Barrel', true )
		self:HideBone( 'MissileLauncher', true )
		self:SetWeaponEnabledByLabel('MG', false)
		self:SetWeaponEnabledByLabel('MissileLauncher', false)
		self:SetWeaponEnabledByLabel('Cannon', false)
		self:SetWeaponEnabledByLabel('GatlingCannon', false)
		self:SetWeaponEnabledByLabel('Mortar', true)
		self:SetWeaponEnabledByLabel('Flamethrower', false)
		end
		end
		)
    end,
}

TypeClass = UEBMD0100