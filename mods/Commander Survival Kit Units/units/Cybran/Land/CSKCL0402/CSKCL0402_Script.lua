#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0303/URL0303_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/defaultunits.lua').MobileUnit
local cWeapons = import('/lua/cybranweapons.lua')
local CDFHeavyMicrowaveLaserGeneratorCom = cWeapons.CDFHeavyMicrowaveLaserGeneratorCom
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat


CSKCL0402 = Class(CLandUnit) 
{
    Walking = false,
    IsWaiting = false,
    PlayEndAnimDestructionEffects = false,

    Weapons = {
        MainGun = Class(CDFHeavyMicrowaveLaserGeneratorCom) {},	
    },
	
    
    OnStopBeingBuilt = function(self, builder, layer)
        CLandUnit.OnStopBeingBuilt(self,builder,layer)
		local rotation = RandomFloat(0,2*math.pi)
		local size = RandomFloat(10.75,10.0)
		CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())
		self.OpenAnimManip = CreateAnimator(self)
        self.Trash:Add(self.OpenAnimManip)
        self.OpenAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(0.5)
		self:RemoveCommandCap('RULEUCC_Move')
		self:RemoveCommandCap('RULEUCC_Guard')
		self:RemoveCommandCap('RULEUCC_Patrol')
    end,
	
	OnMotionHorzEventChange = function(self, new, old)
        CLandUnit.OnMotionHorzEventChange(self, new, old)
        if self:IsDead() then return end
        if( self.IsWaiting ) then
            if( self.Walking ) then
                if( old == 'Stopped' ) then
					local rotation = RandomFloat(0,2*math.pi)
					local size = RandomFloat(10.75,10.0)
					CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())
                elseif( new == 'Stopped' ) then
                    
                end
            end
        end
    end,
	
	OnScriptBitSet = function(self, bit)
        CLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		ForkThread( function()
						self:SetPaused(true)
						self:SetImmobile(true)
						self:SetUnSelectable(true)
						local rotation = RandomFloat(0,2*math.pi)
						local size = RandomFloat(10.75,10.0)
						self.Effect1 = CreateAttachedEmitter(self,'CSKCL0402',self:GetArmy(), '/effects/emitters/dust_cloud_05_emit.bp'):ScaleEmitter(5):SetEmitterParam('LIFETIME', 200)
						self.Trash:Add(self.Effect1)
						self.Effect2 = CreateAttachedEmitter(self,'CSKCL0402',self:GetArmy(), '/effects/emitters/dust_cloud_06_emit.bp'):ScaleEmitter(10):SetEmitterParam('LIFETIME', 200):OffsetEmitter(0,-1,0)
						self:ShakeCamera(200, 1, 0, 20)
						self.Trash:Add(self.Effect2)
						CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())
						self:SetWeaponEnabledByLabel('MainGun', false)
                        self.OpenAnimManip:SetRate(-0.5)
						WaitFor(self.OpenAnimManip)
						self.Worm = CreateSlider(self, 'B00', 0, -400, 0, 25)
                        self.Trash:Add(self.Worm)
						WaitFor(self.Worm)
						self:SetUnSelectable(false)
						self:SetDoNotTarget(true)
						self:AddCommandCap('RULEUCC_Move')
						self:AddCommandCap('RULEUCC_Guard')
						self:AddCommandCap('RULEUCC_Patrol')
						self:SetImmobile(false)
            end
        )
        end
    end,

    OnScriptBitClear = function(self, bit)
        CLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		ForkThread( function()
						self:SetPaused(true)
						self:SetImmobile(true)
						self:SetUnSelectable(true)
						local rotation = RandomFloat(0,2*math.pi)
						local size = RandomFloat(10.75,10.0)
						self.Effect1 = CreateAttachedEmitter(self,'CSKCL0402',self:GetArmy(), '/effects/emitters/dust_cloud_05_emit.bp'):ScaleEmitter(5):SetEmitterParam('LIFETIME', 200)
						self.Trash:Add(self.Effect1)
						self.Effect2 = CreateAttachedEmitter(self,'CSKCL0402',self:GetArmy(), '/effects/emitters/dust_cloud_06_emit.bp'):ScaleEmitter(10):SetEmitterParam('LIFETIME', 200):OffsetEmitter(0,-1,0)
						self:ShakeCamera(200, 1, 0, 20)
						self.Trash:Add(self.Effect2)
						CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())
						self.Worm = CreateSlider(self, 'B00', 0, 400, 0, 25)
                        self.Trash:Add(self.Worm)
						WaitFor(self.Worm)
                        self.OpenAnimManip:SetRate(0.5)
						WaitFor(self.OpenAnimManip)
						self:SetWeaponEnabledByLabel('MainGun', true)
						self:SetUnSelectable(false)
						self:SetDoNotTarget(false)
						self:RemoveCommandCap('RULEUCC_Move')
						self:RemoveCommandCap('RULEUCC_Guard')
						self:RemoveCommandCap('RULEUCC_Patrol')
						self:SetImmobile(false)
            end
        )
        end
    end,

}

TypeClass = CSKCL0402