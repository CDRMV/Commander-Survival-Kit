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
local SDFChronotronCannonWeapon = import('/lua/seraphimweapons.lua').SDFChronotronCannonWeapon
local SIFLaanseTacticalMissileLauncher = import('/lua/seraphimweapons.lua').SIFLaanseTacticalMissileLauncher
local utilities = import('/lua/utilities.lua')
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'

XSB8800 = Class(SWalkingLandUnit) {
	decal = nil, 
    Weapons = {
        Gun01 = Class(SDFOhCannon) {},
		Gun02 = Class(SDFOhCannon) {},
		Gun03 = Class(SDFOhCannon) {},
		Gun04 = Class(SDFOhCannon) {},
		Gun05 = Class(SDFOhCannon) {},
		Gun06 = Class(SDFOhCannon) {},
		ChronotronCannon = Class(SDFChronotronCannonWeapon) {},
        Missile = Class(SIFLaanseTacticalMissileLauncher) {
            OnCreate = function(self)
                SIFLaanseTacticalMissileLauncher.OnCreate(self)
                self:SetWeaponEnabled(false)
            end,
        },
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
		self:SetWeaponEnabledByLabel('Missile', false)
		self:SetWeaponEnabledByLabel('ChronotronCannon', false)
		self:SetWeaponEnabledByLabel('Gun01', false)
		self:SetWeaponEnabledByLabel('Gun02', false)
		self:SetWeaponEnabledByLabel('Gun03', false)
		self:SetWeaponEnabledByLabel('Gun04', false)
		self:SetWeaponEnabledByLabel('Gun05', false)
		self:SetWeaponEnabledByLabel('Gun06', false)
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
		self:HideBone( 'Orb_B03', true )
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
				self:SetWeaponEnabledByLabel('ChronotronCannon', true)
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
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:SetScriptBit('RULEUTC_WeaponToggle', false)
		end)
        elseif enh =='MovableModeRemove' then
		--self:AddToggleCap('RULEUTC_WeaponToggle')
		--self:SetScriptBit('RULEUTC_WeaponToggle', false)
		elseif enh =='MissileLauncher' then
		self:SetWeaponEnabledByLabel('Missile', true)
		self:ShowBone( 'Orb_B03', true )
        elseif enh =='MissileLauncherRemove' then
		self:SetWeaponEnabledByLabel('Missile', false)
		self:HideBone( 'Orb_B03', true )
		elseif enh =='SecondaryCannons1' then
		self:SetWeaponEnabledByLabel('Gun03', true)
		self:SetWeaponEnabledByLabel('Gun04', true)
		self:SetWeaponEnabledByLabel('Gun05', true)
		self:SetWeaponEnabledByLabel('Gun06', true)
		self:ShowBone( 'Orb_B01', true )
        elseif enh =='SecondaryCannons1Remove' then
		self:SetWeaponEnabledByLabel('Gun03', false)
		self:SetWeaponEnabledByLabel('Gun04', false)
		self:SetWeaponEnabledByLabel('Gun05', false)
		self:SetWeaponEnabledByLabel('Gun06', false)
		self:HideBone( 'Orb_B01', true )
		self:HideBone( 'Orb_B03', true )
		elseif enh =='SecondaryCannons' then
		self:SetWeaponEnabledByLabel('Gun01', true)
		self:SetWeaponEnabledByLabel('Gun02', true)
		self:ShowBone( 'Orb_B02', true )
        elseif enh =='SecondaryCannonsRemove' then
		self:SetWeaponEnabledByLabel('Gun01', false)
		self:SetWeaponEnabledByLabel('Gun02', false)
		self:HideBone( 'Orb_B02', true )
		elseif enh =='AmmoSensor' then
		local wep1 = self:GetWeaponByLabel('ChronotronCannon')
		wep1:ChangeMaxRadius(60)
        wep1:ChangeDamage(150)
		local wep2 = self:GetWeaponByLabel('Gun01')
		wep2:ChangeMaxRadius(40)
        wep2:ChangeDamage(65)
		local wep3 = self:GetWeaponByLabel('Gun02')
		wep3:ChangeMaxRadius(40)
        wep3:ChangeDamage(65)
		local wep4 = self:GetWeaponByLabel('Gun03')
		wep4:ChangeMaxRadius(40)
        wep4:ChangeDamage(65)
		local wep5 = self:GetWeaponByLabel('Gun04')
		wep5:ChangeMaxRadius(40)
        wep5:ChangeDamage(65)
		local wep6 = self:GetWeaponByLabel('Gun05')
		wep6:ChangeMaxRadius(40)
        wep6:ChangeDamage(65)
		local wep7 = self:GetWeaponByLabel('Gun06')
		wep7:ChangeMaxRadius(40)
        wep7:ChangeDamage(65)
		local wep8 = self:GetWeaponByLabel('Missile')
		wep8:ChangeMaxRadius(80)
        wep8:ChangeDamage(500)
		self:ShowBone( 'B01_Orbs', true )
        elseif enh =='AmmoSensorRemove' then
		local wep1 = self:GetWeaponByLabel('ChronotronCannon')
		wep1:ChangeMaxRadius(40)
        wep1:ChangeDamage(100)
		local wep2 = self:GetWeaponByLabel('Gun01')
		wep2:ChangeMaxRadius(30)
        wep2:ChangeDamage(45)
		local wep3 = self:GetWeaponByLabel('Gun02')
		wep3:ChangeMaxRadius(30)
        wep3:ChangeDamage(45)
		local wep4 = self:GetWeaponByLabel('Gun03')
		wep4:ChangeMaxRadius(30)
        wep4:ChangeDamage(45)
		local wep5 = self:GetWeaponByLabel('Gun04')
		wep5:ChangeMaxRadius(30)
        wep5:ChangeDamage(45)
		local wep6 = self:GetWeaponByLabel('Gun05')
		wep6:ChangeMaxRadius(30)
        wep6:ChangeDamage(45)
		local wep7 = self:GetWeaponByLabel('Gun06')
		wep7:ChangeMaxRadius(30)
        wep7:ChangeDamage(45)
		local wep8 = self:GetWeaponByLabel('Missile')
		wep8:ChangeMaxRadius(60)
        wep8:ChangeDamage(400)
		self:HideBone( 'B01_Orbs', true )
		self:HideBone( 'Orb_B02', true )
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
TypeClass = XSB8800