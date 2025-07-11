#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0305/UEA0305_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Gunship Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TWeapons = import('/lua/terranweapons.lua')
local TDFGaussCannonWeapon = TWeapons.TDFGaussCannonWeapon

CSKMDTA0300 = Class(TAirUnit) {
    
    EngineRotateBones = {'Jet_Front', 'Jet_Back',},
    BeamExhaustCruise = '/effects/emitters/gunship_thruster_beam_01_emit.bp',
    BeamExhaustIdle = '/effects/emitters/gunship_thruster_beam_02_emit.bp',
    
    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'AC_Muzzle' then
		CreateAttachedEmitter(self.unit, 'AC_Shell', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		},
    },
    
    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self:RemoveCommandCap('RULEUCC_Transport')
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/Mods/Commander Survival Kit Units/units/Addon/Official/Mechdivers/UEF/CSKMDTA0300/CSKMDTA0300_Door.sca', false):SetRate(0)
        self.EngineManipulators = {}

        # create the engine thrust manipulators
        for key, value in self.EngineRotateBones do
            table.insert(self.EngineManipulators, CreateThrustController(self, 'Thruster', value))
        end

        # set up the thursting arcs for the engines
        for key,value in self.EngineManipulators do
            #                          XMAX, XMIN, YMAX,YMIN, ZMAX,ZMIN, TURNMULT, TURNSPEED
            value:SetThrustingParam( -0.0, 0.0, -0.25, 0.25, -0.1, 1, 1.0,      0.25 )
        end

        for k, v in self.EngineManipulators do
            self.Trash:Add(v)
        end

    end,
	
	OnMotionVertEventChange = function(self, new, old)
            TAirUnit.OnMotionVertEventChange(self, new, old)
            if (new == 'Bottom') then
			self:AddToggleCap('RULEUTC_WeaponToggle')
            elseif (old == 'Bottom') then
			if self:GetScriptBit('RULEUTC_WeaponToggle') == true then
			self:SetScriptBit('RULEUTC_WeaponToggle', false)
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			self:RemoveToggleCap('RULEUTC_SpecialToggle')
			else
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			self:RemoveToggleCap('RULEUTC_SpecialToggle')
			end
            end
        end,
	
	OnScriptBitSet = function(self, bit)
        TAirUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self.AnimationManipulator:SetRate(1)
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition('BeaconPos')
		self.Beacon = CreateUnitHPR('UEB5102', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		self:AddToggleCap('RULEUTC_ShieldToggle')
		self:SetScriptBit('RULEUTC_ShieldToggle', true)
		LOG(self:GetScriptBit(7))
		elseif bit == 7 then
		local position = self.Beacon:GetPosition()
			local units = self.Beacon:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND + categories.TECH1, position, 10, 'Ally')
			local number = 0
            for _,unit in units do
			if unit:IsUnitState('WaitForFerry') and unit:GetBlueprint().General.UnitName == '<LOC uel0106_name>Mech Marine' then
			if number < 5 then
			unit:AttachBoneTo(-2, self, 0)
			number = number + 1
			else
			end
			else
            end
			end
		elseif bit == 0 then
		self.Beacon:ShowBone(0, true)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TAirUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:RemoveToggleCap('RULEUTC_ShieldToggle')
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self.Beacon:Destroy()
		self.AnimationManipulator:SetRate(-1)
		elseif bit == 7 then
		local units = self:GetCargo()
		local position = self.Beacon:GetPosition()
        for _, unit in units do
			Warp(unit, {position[1] + math.random(-1,1), GetTerrainHeight(position[1], position[3]), position[3] + math.random(-1,1)}, self.Beacon:GetOrientation())
			unit:DetachFrom(true)
        end
		elseif bit == 0 then
		self.Beacon:HideBone(0, true)
        end
    end,

}
TypeClass = CSKMDTA0300