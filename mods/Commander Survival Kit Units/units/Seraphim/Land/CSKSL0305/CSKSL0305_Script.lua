#****************************************************************************
#**
#**  File     :  /units/XSL0202/XSL0202_script.lua
#**
#**  Summary  :  Seraphim Heavy Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local SDFOhCannon = import('/lua/seraphimweapons.lua').SDFOhCannon
local utilities = import('/lua/utilities.lua')

CSKSL0305 = Class(SWalkingLandUnit) {
    Weapons = {
        Gun01 = Class(SDFOhCannon) {},
		Gun02 = Class(SDFOhCannon) {},
		Gun03 = Class(SDFOhCannon) {}
    },
	
	OnLayerChange = function(self, new, old)
        SWalkingLandUnit.OnLayerChange(self, new, old)
            if (new == 'Land') and (old != 'None') then
				self:AddToggleCap('RULEUTC_WeaponToggle')
            elseif (new == 'Seabed') then
				self:RemoveToggleCap('RULEUTC_WeaponToggle')
            end
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        SWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetWeaponEnabledByLabel('Gun01', false)
		self:SetWeaponEnabledByLabel('Gun02', false)
		self:SetWeaponEnabledByLabel('Gun03', false)
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:HideBone( 'Orb', true )
		self:HideBone( 'B01_Orbs', true )
		self.OpenAnimManip = CreateAnimator(self)
        self.Trash:Add(self.OpenAnimManip)
        self.OpenAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(0)
		if self:GetAIBrain().BrainType != 'Human' then
		else
        end
        self:RequestRefreshUI()
		self.UnitComplete = true
    end,
	
	OnScriptBitSet = function(self, bit)
        SWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
			ForkThread( function()
			self:SetUnSelectable(true)
			self:SetImmobile(true)
			self:RemoveCommandCap('RULEUCC_Move')
			self:RemoveCommandCap('RULEUCC_Guard')
			self:RemoveCommandCap('RULEUCC_Patrol')
			self.OpenAnimManip:SetRate(1)
			WaitFor(self.OpenAnimManip)
			self:ShowBone( 'Orb', true )
			self:ShowBone( 'B01_Orbs', true )
			self:SetUnSelectable(false)
			self:AddCommandCap('RULEUCC_Attack')
			self:AddCommandCap('RULEUCC_RetaliateToggle')
			self:SetWeaponEnabledByLabel('Gun01', true)
			self:SetWeaponEnabledByLabel('Gun02', true)
			self:SetWeaponEnabledByLabel('Gun03', true)
			end)
        end
    end,

    OnScriptBitClear = function(self, bit)
        SWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
			ForkThread( function()
			self:SetWeaponEnabledByLabel('Gun01', false)
			self:SetWeaponEnabledByLabel('Gun02', false)
			self:SetWeaponEnabledByLabel('Gun03', false)
			self:RemoveCommandCap('RULEUCC_Attack')
			self:RemoveCommandCap('RULEUCC_RetaliateToggle')
			self:HideBone( 'Orb', true )
			self:HideBone( 'B01_Orbs', true )
			self:SetUnSelectable(true)
			self.OpenAnimManip:SetRate(-1)
			WaitFor(self.OpenAnimManip)
			self:AddCommandCap('RULEUCC_Move')
			self:AddCommandCap('RULEUCC_Guard')
			self:AddCommandCap('RULEUCC_Patrol')
			self:SetImmobile(false)
			self:SetUnSelectable(false)
			end)
        end
    end,
	
	DeathThread = function( self, overkillRatio, instigator)

        #LOG('*DEBUG: OVERKILL RATIO = ', repr(overkillRatio))

        WaitSeconds( utilities.GetRandomFloat( self.DestructionExplosionWaitDelayMin, self.DestructionExplosionWaitDelayMax) )
        self:DestroyAllDamageEffects()

        if self.PlayDestructionEffects then
            self:CreateDestructionEffects( self, overkillRatio )
        end

        #MetaImpact( self, self:GetPosition(), 0.1, 0.5 )
		if self:GetScriptBit(1) == false then
        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
            if self.PlayDestructionEffects and self.PlayEndAnimDestructionEffects then
                self:CreateDestructionEffects( self, overkillRatio )
            end
		end	
		else
		    if self.PlayDestructionEffects and self.PlayEndAnimDestructionEffects then
                self:CreateDestructionEffects( self, overkillRatio )
            end
        end

        self:CreateWreckage( overkillRatio )

        # CURRENTLY DISABLED UNTIL DESTRUCTION
        # Create destruction debris out of the mesh, currently these projectiles look like crap,
        # since projectile rotation and terrain collision doesn't work that great. These are left in
        # hopes that this will look better in the future.. =)
        if( self.ShowUnitDestructionDebris and overkillRatio ) then
            if overkillRatio <= 1 then
                self.CreateUnitDestructionDebris( self, true, true, false )
            elseif overkillRatio <= 2 then
                self.CreateUnitDestructionDebris( self, true, true, false )
            elseif overkillRatio <= 3 then
                self.CreateUnitDestructionDebris( self, true, true, true )
            else #VAPORIZED
                self.CreateUnitDestructionDebris( self, true, true, true )
            end
        end

        #LOG('*DEBUG: DeathThread Destroying in ',  self.DeathThreadDestructionWaitTime )
        WaitSeconds(self.DeathThreadDestructionWaitTime)

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,

}
TypeClass = CSKSL0305