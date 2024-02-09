#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0106/UEL0106_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Light Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local Util = import('/lua/utilities.lua')
local ModTexPath = '/mods/Commander Survival Kit Units/textures/particles/'
local ModEmPath = '/mods/Commander Survival Kit Units/effects/emitters/'
   
CSKTL0101 = Class(TWalkingLandUnit) {
    Weapons = {
        ArmCannonTurret = Class(TDFMachineGunWeapon) {
            DisabledFiringBones = {
                'Torso', 'Head',  'Arm_Right_B01', 'Arm_Right_B02','Arm_Right_Muzzle',
                'Arm_Left_B01', 'Arm_Left_B02','Arm_Left_Muzzle'
            },
        },
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        TWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.JetPackEffectsBag = {}
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
	end,
	
	OnMotionHorzEventChange = function(self, new, old)
        TWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
		if old == 'Stopped' then
			self:AddToggleCap('RULEUTC_WeaponToggle')
			self:SetScriptBit('RULEUTC_WeaponToggle', false)
        elseif new == 'Stopped' then
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
        end
    end,
	
	
OnScriptBitSet = function(self, bit)
	local Oldlocation = self:GetPosition()
	local MovePos = self:GetCurrentMoveLocation()
	local Bombers = {} 
	local bp = self:GetBlueprint()
	local AirDummyUnit = bp.Display.AirDummyUnit
        if bit == 1 then 
			LOG('ScriptBit: ',self:GetScriptBit(2))
			LOG('MovePos: ',MovePos)
			ForkThread( function()
			local aiBrain = self:GetAIBrain()
			local qx, qy, qz, qw = unpack(self:GetOrientation())
			Bombers[1] = CreateUnit(AirDummyUnit,1,Oldlocation[1], Oldlocation[2], Oldlocation[3],qx, qy, qz, qw, 0)
			self:AttachBoneTo(-2, Bombers[1], 0)
			for i, Bomber in Bombers do
			EffectBones = self:GetBlueprint().Display.JetPackEffectBones
			self.Rotator1 = CreateRotator(self, 'Left_Booster', 'X', 20, 40, 0, 0)
			self.Rotator2 = CreateRotator(self, 'Right_Booster', 'X', 20, 40, 0, 0)
			self.Effect1 = CreateAttachedEmitter(self,EffectBones[1],self:GetArmy(), ModEmPath .. 'jetpack_trail_01_emit.bp'):OffsetEmitter(0 ,0, -0.4):ScaleEmitter(0.5)
            self.Trash:Add(self.Effect1)
			self.Effect2 = CreateAttachedEmitter(self,EffectBones[2],self:GetArmy(), ModEmPath .. 'jetpack_trail_01_emit.bp'):OffsetEmitter(0 ,0, -0.4):ScaleEmitter(0.5)
            self.Trash:Add(self.Effect2)
			self.Effect3 = CreateAttachedBeam(self,EffectBones[1],self:GetArmy(),  0.2, 0.05, ModTexPath .. 'beam_jetpack_exhaust.dds')
            self.Trash:Add(self.Effect3)
			self.Effect4 = CreateAttachedBeam(self,EffectBones[2],self:GetArmy(), 0.2, 0.05, ModTexPath .. 'beam_jetpack_exhaust.dds')
            self.Trash:Add(self.Effect4)
			Bombers[1]:SetElevation(10)
            IssueTransportUnload({Bomber}, MovePos)
            end
			while true do
			WaitSeconds(1)
			if Bombers[1]:IsUnitState('TransportUnloading') then
			self.Rotator1 = CreateRotator(self, 'Left_Booster', 'X', 60, 40, 0, 0)
			self.Rotator2 = CreateRotator(self, 'Right_Booster', 'X', 60, 40, 0, 0)
			break
			end
			end
			while true do
			WaitSeconds(1)
			if Bombers[1]:IsUnitState('MovingDown') then
			self.Rotator1 = CreateRotator(self, 'Left_Booster', 'X', -100, 40, 0, 0)
			self.Rotator2 = CreateRotator(self, 'Right_Booster', 'X', -100, 40, 0, 0)
			break
			end
			end
			end
			)
        end
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 1 then 
			self.Rotator1 = CreateRotator(self, 'Left_Booster', 'X', 20, 40, 0, 0)
			self.Rotator2 = CreateRotator(self, 'Right_Booster', 'X', 20, 40, 0, 0)
			self.Effect1:Destroy()
			self.Effect2:Destroy()
			self.Effect3:Destroy()
			self.Effect4:Destroy()
        end
    end,
	
	

}
TypeClass = CSKTL0101

