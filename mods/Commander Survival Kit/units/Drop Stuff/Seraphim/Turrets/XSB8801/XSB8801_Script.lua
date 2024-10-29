#****************************************************************************
#**
#**  File     :  /units/XSL0202/XSL0202_script.lua
#**
#**  Summary  :  Seraphim Heavy Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local SIFZthuthaamArtilleryCannon = import('/lua/seraphimweapons.lua').SIFZthuthaamArtilleryCannon
local SDFMiniChromaticBeamGenerator = import('/mods/Commander Survival Kit/lua/FireSupportBarrages.lua').SDFMiniChromaticBeamGenerator
local Effects = '/mods/Commander Survival Kit/effects/emitters/seraphim_chromatic_beam_generator_beam03_emit.bp'
local utilities = import('/lua/utilities.lua')

XSB8801 = Class(SWalkingLandUnit) {
    Weapons = {
        FrontTurret = Class(SDFMiniChromaticBeamGenerator) {
		
			OnWeaponFired = function(self)
				if self.unit.BeamUpgrade1 == true then
				if self.unit.Interval == 0 then
				table.insert( self.unit.BeamChargeEffects, AttachBeamEntityToEntity(self.unit, 'Laser_Effect03', self.unit, 'Orb_Effect', self.unit:GetArmy(), Effects ))
				table.insert( self.unit.BeamChargeEffects, AttachBeamEntityToEntity(self.unit, 'Laser_Effect04', self.unit, 'Orb_Effect', self.unit:GetArmy(), Effects ))
				table.insert( self.unit.BeamChargeEffects, AttachBeamEntityToEntity(self.unit, 'Laser_Effect05', self.unit, 'Orb_Effect', self.unit:GetArmy(), Effects ))
				table.insert( self.unit.BeamChargeEffects, AttachBeamEntityToEntity(self.unit, 'Laser_Effect06', self.unit, 'Orb_Effect', self.unit:GetArmy(), Effects ))
				self.unit.Interval = self.unit.Interval + 1
				end
				self.unit:ShowBone( 'Orb_Effect', true )
				end
               	self.unit:ShowBone( 'Laser_Effect01', true )
				self.unit:ShowBone( 'Laser_Effect02', true )
                SDFMiniChromaticBeamGenerator.OnLostTarget(self)             
            end,
		
		    OnLostTarget = function(self)
				if self.unit.BeamUpgrade1 == true then
				if self.unit.BeamChargeEffects then
					for k, v in self.unit.BeamChargeEffects do
						v:Destroy()
					end
					self.unit.BeamChargeEffects = {}
				end
				self.unit:HideBone( 'Orb_Effect', true )
				self.unit.Interval = 0
				end
                self.unit:HideBone( 'Laser_Effect01', true )
				self.unit:HideBone( 'Laser_Effect02', true )
                SDFMiniChromaticBeamGenerator.OnLostTarget(self)             
            end,
		
		},
		MainGun = Class(SIFZthuthaamArtilleryCannon) {},
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
		local wep1 = self:GetWeaponByLabel('MainGun')
		wep1:SetEnabled(false)
		self.BeamUpgrade1 = false
		self.ArtUpgrade = false
		self.Interval = 0
		self.BeamChargeEffects = {}
		self:HideBone( 'Armor', true )
		self:HideBone( 'Orb_B01', true )
		self:HideBone( 'Orb_B02', true )
		self:HideBone( 'Orb_Effect', true )
		self:HideBone( 'Laser_Effect01', true )
		self:HideBone( 'Laser_Effect02', true )
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
			self:SetUnSelectable(false)
			end)
        end
    end,

    OnScriptBitClear = function(self, bit)
        SWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
			ForkThread( function()
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
	
	CreateEnhancement = function(self, enh)
        SWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
		if enh =='Armor' then
		if self:GetScriptBit(1) == true then
		self:ShowBone('Armor', false)
		self:HideBone( 'R_Leg_B01', true )
		self:HideBone( 'L_Leg_B01', true )
		self:HideBone( 'Leg_B01', true )
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		else
		ForkThread( function()
		self:SetScriptBit('RULEUTC_WeaponToggle', true)
		WaitSeconds(1)
		self:ShowBone('Armor', false)
		self:HideBone( 'R_Leg_B01', true )
		self:HideBone( 'L_Leg_B01', true )
		self:HideBone( 'Leg_B01', true )
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		end)
		end
        elseif enh =='ArmorRemove' then
		ForkThread( function()
		self:HideBone('Armor', false)
		self:ShowBone( 'R_Leg_B01', true )
		self:ShowBone( 'L_Leg_B01', true )
		self:ShowBone( 'Leg_B01', true )
		self:SetMaxHealth(5000)
		self:SetHealth(self, 5000)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:SetScriptBit('RULEUTC_WeaponToggle', false)
		end)
		elseif enh =='MovableMode' then
		ForkThread( function()
		self:HideBone('Armor', false)
		self:ShowBone( 'R_Leg_B01', true )
		self:ShowBone( 'L_Leg_B01', true )
		self:ShowBone( 'Leg_B01', true )
		self:SetMaxHealth(5000)
		self:SetHealth(self, 5000)
		if self.ArtUpgrade == true then
		
		else
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:SetScriptBit('RULEUTC_WeaponToggle', false)
		end
		end)
        elseif enh =='MovableModeRemove' then
		--self:AddToggleCap('RULEUTC_WeaponToggle')
		--self:SetScriptBit('RULEUTC_WeaponToggle', false)
		elseif enh =='SupportBeamFocusEmitters' then
		self.BeamUpgrade1 = true
		self:ShowBone( 'Orb_B02', true )
        elseif enh =='SupportBeamFocusEmittersRemove' then
		self.BeamUpgrade1 = false
		self:HideBone( 'Orb_B02', true )
		elseif enh =='BeamImprover' then
		self:ShowBone( 'Orb_B01', true )
        elseif enh =='BeamImproverRemove' then
		self.BeamUpgrade1 = false
		self:HideBone( 'Orb_B01', true )
		self:HideBone( 'Orb_B02', true )
		elseif enh =='Artillery' then
		self.ArtUpgrade = true
		self:SetScriptBit('RULEUTC_WeaponToggle', true)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		local wep1 = self:GetWeaponByLabel('MainGun')
		wep1:SetEnabled(true)
		local wep2 = self:GetWeaponByLabel('FrontTurret')
		wep2:SetEnabled(false)
		self:ShowBone( 'Orb_B01', true )
        elseif enh =='ArtilleryRemove' then
		self.ArtUpgrade = false
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:SetScriptBit('RULEUTC_WeaponToggle', false)
		local wep1 = self:GetWeaponByLabel('MainGun')
		wep1:SetEnabled(false)
		local wep2 = self:GetWeaponByLabel('FrontTurret')
		wep2:SetEnabled(true)
		self:HideBone( 'Orb_B01', true )
		elseif enh =='AmmoSensor' then
		local wep1 = self:GetWeaponByLabel('ChronotronCannon')
		wep1:ChangeMaxRadius(60)
        wep1:ChangeDamage(150)
		self:ShowBone( 'B01_Orbs', true )
        elseif enh =='AmmoSensorRemove' then
		local wep1 = self:GetWeaponByLabel('ChronotronCannon')
		wep1:ChangeMaxRadius(40)
        wep1:ChangeDamage(100)
		self:HideBone( 'B01_Orbs', true )
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
TypeClass = XSB8801