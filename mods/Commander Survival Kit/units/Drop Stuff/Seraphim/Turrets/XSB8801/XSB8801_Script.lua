#****************************************************************************
#**
#**  File     :  /units/XSL0202/XSL0202_script.lua
#**
#**  Summary  :  Seraphim Heavy Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SWalkingLandUnit = import('/lua/defaultunits.lua').ConstructionUnit
local SIFZthuthaamArtilleryCannon = import('/lua/seraphimweapons.lua').SIFZthuthaamArtilleryCannon
local SDFMiniChromaticBeamGenerator = import('/mods/Commander Survival Kit/lua/FireSupportBarrages.lua').SDFMiniChromaticBeamGenerator
local Effects = '/mods/Commander Survival Kit/effects/emitters/seraphim_chromatic_beam_generator_beam03_emit.bp'
local utilities = import('/lua/utilities.lua')
local CreateSeraphimBuildBeams = import('/lua/effectutilities.lua').CreateSeraphimBuildBeams
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'


XSB8801 = Class(SWalkingLandUnit) {
	decal = nil, 
    Weapons = {
		MainGun = Class(SIFZthuthaamArtilleryCannon) {},
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
    },
	
	OnMotionHorzEventChange = function(self, new, old)
	SWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
	ForkThread( function()
		if old == 'Stopped' then
			self.WalkAnimManip = CreateAnimator(self)
			self.Trash:Add(self.WalkAnimManip)
			self.WalkAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationWalk, true):SetRate(self:GetBlueprint().Display.AnimationWalkRate)
        elseif new == 'Stopped' then
			self.WalkAnimManip:SetRate(0)
			self.WalkAnimManip:Destroy()
        end
	end)
    end,
	
	OnLayerChange = function(self, new, old)
        SWalkingLandUnit.OnLayerChange(self, new, old)
            if (new == 'Land') and (old != 'None') then
				self:AddToggleCap('RULEUTC_WeaponToggle')
            elseif (new == 'Seabed') then
				self:RemoveToggleCap('RULEUTC_WeaponToggle')
            end
    end,
	
	
	CreateBuildEffects = function( self, unitBeingBuilt, order )
        local UpgradesFrom = unitBeingBuilt:GetBlueprint().General.UpgradesFrom
        # If we are assisting an upgrading unit, or repairing a unit, play seperate effects
        if (order == 'Repair' and not unitBeingBuilt:IsBeingBuilt()) or (UpgradesFrom and UpgradesFrom != 'none' and self:IsUnitState('Guarding'))then
            CreateSeraphimBuildBeams( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
        end           
    end, 
	
	
	OnStopBeingBuilt = function(self,builder,layer)
        SWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetDoNotTarget(true)
		self:AddBuildRestriction(categories.SERAPHIM * categories.BUILTBYTIER3ENGINEER)
		local wep0 = self:GetWeaponByLabel('MainGun')
		wep0:SetEnabled(false)
		local wep1 = self:GetWeaponByLabel('FrontTurret')
		wep1:SetEnabled(false)
		self.BeamUpgrade1 = false
		self.ArtUpgrade = false
		self.AmmoUpgrade = false
		self.ArmorUpgrade = false
		self.Interval = 0
		self.BeamChargeEffects = {}
		self:ForkThread(function()
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationArrival, false):SetRate(0)	
		local army = self:GetArmy()
        local position = self:GetPosition()
		local orientation = RandomFloat(0,2*math.pi)
		self.ArmSlider1 = CreateSlider(self, 'Body')
        self.Trash:Add(self.ArmSlider1)
		self.ArmSlider1:SetGoal(0, 1000, 0)
		self.ArmSlider1:SetSpeed(1000)
		self:HideBone('Body', true) 
		self:HideBone( 'Armor', true )
        self:SetUnSelectable(true)	
		WaitSeconds(5)			
		self.ArmSlider1 = CreateSlider(self, 'Body')
		self.Trash:Add(self.ArmSlider1)        
		self.ArmSlider1:SetGoal(0, -1000, 0)
		self.ArmSlider1:SetSpeed(500)
		self:ShowBone('Body', true) 
		self.ArrivalEffect1 = CreateAttachedEmitter(self,'Body',self:GetArmy(), '/effects/emitters/nuke_munition_launch_trail_05_emit.bp'):ScaleEmitter(4):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1):SetEmitterParam('REPEATTIME', -1)
		self.ArrivalEffect2 = CreateAttachedEmitter(self,'Body',self:GetArmy(), '/effects/emitters/nuke_munition_launch_trail_02_emit.bp'):ScaleEmitter(4):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1):SetEmitterParam('REPEATTIME', -1)
		self:HideBone( 'Armor', true )
		self:HideBone( 'Orb_B01', true )
		self:HideBone( 'Orb_B02', true )
		self:HideBone( 'Orb_Effect', true )
		self:HideBone( 'Laser_Effect01', true )
		self:HideBone( 'Laser_Effect02', true )
		self:HideBone( 'B01_Orbs', true )
		self.number = 0
		self.DimensionalExplosion = false
		self.ArmorUpgrade = false
		self.ShieldEffectsBag = {}
		self.OpenAnimManip = CreateAnimator(self)
        self.Trash:Add(self.OpenAnimManip)
        self.OpenAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(0)
		WaitSeconds(2)
		CreateEmitterOnEntity(self,self:GetArmy(), '/effects/emitters/destruction_explosion_flash_04_emit.bp')
		CreateEmitterOnEntity(self,self:GetArmy(), '/effects/emitters/destruction_explosion_flash_05_emit.bp')
        DamageArea(self, position, 4, 10, 'Force', false, false)
        DamageArea(self, position, 4, 10, 'Fire', false, false)
        CreateDecal(position, orientation, 'Scorch_010_albedo', '', 'Albedo', 12, 12, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 12, 12, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 12, 12, 500, 600, army)
		self.ArrivalEffect1:Destroy()
		self.ArrivalEffect2:Destroy()
		if self.AnimationManipulator then
            self:ForkThread(function()
				self.AnimationManipulator:SetRate(2)
                WaitSeconds(1)
                self.AnimationManipulator:Destroy()
				self:SetUnSelectable(false)	
				local wep1 = self:GetWeaponByLabel('FrontTurret')
				wep1:SetEnabled(true)
				self:SetDoNotTarget(false)
            end)
        end		
        # Scorch decal and light some trees on fire
        DamageRing(self, position, 20, 27, 1, 'Fire', false, false)
		local bp = self:GetBlueprint()
        for i, numWeapons in bp.Weapon do
            if(bp.Weapon[i].Label == 'WalkerArrival') then
                DamageArea(self, self:GetPosition(), bp.Weapon[i].DamageRadius, bp.Weapon[i].Damage, bp.Weapon[i].DamageType, bp.Weapon[i].DamageFriendly)
                break
            end
        end		
		if self:GetAIBrain().BrainType != 'Human' then
		else
        end
        self:RequestRefreshUI()
		self.UnitComplete = true
		end)
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
		if bit == 7 then 
		self.RepairThreadHandle = self:ForkThread(self.RepairThread)
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
		if bit == 7 then 
		KillThread(self.RepairThreadHandle)
        end
    end,
	
	RepairThread = function(self)
		local Pos = self:GetPosition()
		while true do
        while not self:IsDead() do
            local landunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.LAND, 
			self:GetPosition(), 
			25,
			'Ally'
			
			)
			
			local navalunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.NAVAL, 
			self:GetPosition(), 
			25,
			'Ally'
			
			)
			
			for _,landunit in landunits do
				IssueRepair({self}, landunit)
            end
			
			for _,navalunit in navalunits do
				IssueRepair({self}, navalunit)
            end
            
            #Wait 5 seconds
            WaitSeconds(1)
        end
		WaitSeconds(1)
		end
    end,
	
	CreateEnhancement = function(self, enh)
        SWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
		if enh =='Armor' then
		self.ArmorUpgrade = true
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
		self.ArmorUpgrade = false
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
		if self.AmmoUpgrade == true then
		wep1:ChangeMaxRadius(140)
		wep1:SetEnabled(true)
		else
		wep1:ChangeMaxRadius(130)
		wep1:SetEnabled(true)
		end
		local wep2 = self:GetWeaponByLabel('FrontTurret')
		wep2:SetEnabled(false)
		self:ShowBone( 'Orb_B01', true )
        elseif enh =='ArtilleryRemove' then
		if self.ArmorUpgrade == true then
		self.ArtUpgrade = false
		self:AddToggleCap('RULEUTC_WeaponToggle')
		else
		self.ArtUpgrade = false
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:SetScriptBit('RULEUTC_WeaponToggle', false)
		end
		local wep1 = self:GetWeaponByLabel('MainGun')
		wep1:SetEnabled(false)
		local wep2 = self:GetWeaponByLabel('FrontTurret')
		wep2:SetEnabled(true)
		self:HideBone( 'Orb_B01', true )
		elseif enh =='AmmoSensor' then
		self.AmmoUpgrade = true
		local wep1 = self:GetWeaponByLabel('FrontTurret')
		wep1:ChangeMaxRadius(60)
        wep1:ChangeDamage(50)
		local wep2 = self:GetWeaponByLabel('MainGun')
		wep2:ChangeMaxRadius(140)
		wep2:ChangeDamage(2500)
		self:ShowBone( 'B01_Orbs', true )
        elseif enh =='AmmoSensorRemove' then
		self.AmmoUpgrade = false
		local wep1 = self:GetWeaponByLabel('FrontTurret')
		wep1:ChangeMaxRadius(30)
        wep1:ChangeDamage(40)
		local wep2 = self:GetWeaponByLabel('MainGun')
		wep2:ChangeMaxRadius(130)
		wep2:ChangeDamage(2400)
		self:HideBone( 'B01_Orbs', true )
		elseif enh =='RepairMode' then
		local wep1 = self:GetWeaponByLabel('FrontTurret')
		wep1:SetEnabled(false)
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:AddToggleCap('RULEUTC_SpecialToggle')
		self:AddCommandCap('RULEUCC_Repair')
        elseif enh =='RepairModeRemove' then
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self:RemoveCommandCap('RULEUCC_Repair')
		self:AddCommandCap('RULEUCC_Attack')
		self:AddCommandCap('RULEUCC_RetaliateToggle')
		local wep1 = self:GetWeaponByLabel('FrontTurret')
		wep1:SetEnabled(true)
		end
    end,

	
	DeathThread = function( self, overkillRatio, instigator)


        self:DestroyAllDamageEffects()

        if self.PlayDestructionEffects then
            self:CreateDestructionEffects( self, overkillRatio )
        end

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

        if self.PlayDestructionEffects then
            self:CreateDestructionEffects( self, overkillRatio )
        end
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,

}
TypeClass = XSB8801