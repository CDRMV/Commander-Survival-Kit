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
   
CSKTL0101 = Class(TWalkingLandUnit) {
    Weapons = {
        ArmCannonTurret = Class(TDFMachineGunWeapon) {
            DisabledFiringBones = {
                'Torso', 'Head',  'Arm_Right_B01', 'Arm_Right_B02','Arm_Right_Muzzle',
                'Arm_Left_B01', 'Arm_Left_B02','Arm_Left_Muzzle'
            },
        },
    },
	
	
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
			Bombers[1] = CreateUnitHPR(AirDummyUnit,aiBrain.Name,Oldlocation[1], Oldlocation[2], Oldlocation[3],0, 0, 0)
			Bombers[1]:RotateTowards(MovePos)
			self:AttachBoneTo(-2, Bombers[1], 0)
			for i, Bomber in Bombers do
			EffectBones = self:GetBlueprint().Display.JetPackEffectBones
			self.Effect1 = CreateAttachedEmitter(self,EffectBones[1],self:GetArmy(), '/effects/emitters/nuke_munition_trail_01_emit.bp')
            self.Trash:Add(self.Effect1)
			self.Effect2 = CreateAttachedEmitter(self,EffectBones[2],self:GetArmy(), '/effects/emitters/nuke_munition_trail_01_emit.bp')
            self.Trash:Add(self.Effect1)
				Bombers[1]:SetElevation(10)
                IssueTransportUnload({Bomber}, MovePos)
            end
			end
			)
        end
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 1 then 
			self.Effect1:Destroy()
			self.Effect2:Destroy()
        end
    end,
	
	

}
TypeClass = CSKTL0101

