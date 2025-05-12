#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0304/UEA0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Strategic Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local TDFPlasmaCannonWeapon = import('/lua/terranweapons.lua').TDFPlasmaCannonWeapon
local TAirToAirLinkedRailgun = import('/lua/terranweapons.lua').TAirToAirLinkedRailgun
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
CSKTA0313b = Class(TAirUnit) {

EngineRotateBones = {'Gondel',},

    Weapons = {
	AAGun = Class(TAirToAirLinkedRailgun) {},
	AntiAirMissileFlare = Class(TDFGaussCannonWeapon) {
		FxMuzzleFlashScale = 0.25,
	},
	DropFlare = Class(TDFGaussCannonWeapon) {
		FxMuzzleFlashScale = 0.25,
	},
	GatlingCannon = Class(TDFPlasmaCannonWeapon) 
        {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Turret02_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFPlasmaCannonWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'Turret02_Barrel_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TDFPlasmaCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Turret02_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFPlasmaCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
        Turret01 = Class(TDFRiotWeapon) {},
		Turret02 = Class(TDFGaussCannonWeapon) {}
    },
	
	
	OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
		self.Spinners = {
            Spinner1 = CreateRotator(self, 'L_Propeller01', 'y', nil, 0, 360, 360):SetTargetSpeed(5000),
			Spinner3 = CreateRotator(self, 'R_Propeller01', 'y', nil, 0, 360, 360):SetTargetSpeed(5000),
        }
		for k, v in self.Spinners do
            self.Trash:Add(v)
        end
		--self.CheckAntiAirUnitsThreadHandle = self:ForkThread(self.CheckAntiAirUnitsThread)

    end,
	
	
	OnMotionVertEventChange = function(self, new, old)
        TAirUnit.OnMotionHorzEventChange(self, new, old)
		if new == 'Down' then
            -- Play the "landing" sound
            self:PlayUnitSound('Landing')
			Gondel = CreateRotator(self, 'Gondel', 'x', 90, 90, 10, 10)
        elseif new == 'Bottom' or new == 'Hover' then
            -- Play the "landed" sound
            self:PlayUnitSound('Landed')
        elseif new == 'Up' or (new == 'Top' and (old == 'Down' or old == 'Bottom')) then
            -- Play the "takeoff" sound
            self:PlayUnitSound('TakeOff')
			Gondel = CreateRotator(self, 'Gondel', 'x', -90, 90, 10, 10)
        end
    end,
	
	CheckAntiAirUnitsThread = function(self)
		while true do
		local Pos = self:GetPosition()
        while not self:IsDead() do
            local units = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.ANTIAIR,
			self:GetPosition(), 
			50,
			'Enemy'
			
			)
            for _,unit in units do
				self:GetWeaponByLabel'AntiAirMissileFlare':FireWeapon()
            end
            
            WaitSeconds(7)
        end
		WaitSeconds(1)
		end
    end,

	
}

TypeClass = CSKTA0313b
