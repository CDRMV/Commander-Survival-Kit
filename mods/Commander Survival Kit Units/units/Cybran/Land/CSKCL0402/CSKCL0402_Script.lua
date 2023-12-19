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
local CIFArtilleryWeapon = cWeapons.CIFArtilleryWeapon
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat


CSKCL0402 = Class(CLandUnit) 
{
    PlayEndAnimDestructionEffects = false,

    Weapons = {
		Gun01 = Class(CIFArtilleryWeapon) {},		
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
	
	OnScriptBitSet = function(self, bit)
        CLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		ForkThread( function()
						local rotation = RandomFloat(0,2*math.pi)
						local size = RandomFloat(10.75,10.0)
						CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())
						self:SetUnSelectable(true)
						self:SetWeaponEnabledByLabel('Gun01', false)
						self.Effect1 = CreateAttachedEmitter(self,'CSKCL0402',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
						self.Trash:Add(self.Effect1)
                        self.OpenAnimManip:SetRate(-0.5)
						WaitFor(self.OpenAnimManip)
						self.Worm = CreateSlider(self, 'B00', 0, -400, 0, 25)
                        self.Trash:Add(self.Worm)
						self:SetUnSelectable(false)
						self:SetDoNotTarget(true)
						self:AddCommandCap('RULEUCC_Move')
						self:AddCommandCap('RULEUCC_Guard')
						self:AddCommandCap('RULEUCC_Patrol')
            end
        )
        end
    end,

    OnScriptBitClear = function(self, bit)
        CLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		ForkThread( function()
						local rotation = RandomFloat(0,2*math.pi)
						local size = RandomFloat(10.75,10.0)
						CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())
						self:SetUnSelectable(true)
						self.Worm = CreateSlider(self, 'B00', 0, 400, 0, 25)
                        self.Trash:Add(self.Worm)
						WaitFor(self.Worm)
						self.Effect1 = CreateAttachedEmitter(self,'CSKCL0402',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
						self.Trash:Add(self.Effect1)
                        self.OpenAnimManip:SetRate(0.5)
						WaitFor(self.OpenAnimManip)
						self:SetWeaponEnabledByLabel('Gun01', true)
						self:SetUnSelectable(false)
						self:SetDoNotTarget(false)
						self:RemoveCommandCap('RULEUCC_Move')
						self:RemoveCommandCap('RULEUCC_Guard')
						self:RemoveCommandCap('RULEUCC_Patrol')
            end
        )
        end
    end,

}

TypeClass = CSKCL0402