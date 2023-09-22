#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0303/UAL0303_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AWalkingLandUnit = import('/lua/aeonunits.lua').AWalkingLandUnit
local ADFLaserHighIntensityWeapon = import('/lua/aeonweapons.lua').ADFLaserHighIntensityWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

CSKAL0400 = Class(AWalkingLandUnit) {    
    Weapons = {
        FrontTurret01 = Class(ADFLaserHighIntensityWeapon) {}
    },
    
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateAeonCommanderBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
    end,  
	
	
	CreateOuterRingWaveSmokeRing = function(self)
        local sides = 32
        local angle = (2*math.pi) / sides
        local velocity = 7
        local OffsetMod = 8
        local projectiles = {}

        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            local proj =  self:CreateProjectile('/effects/entities/UEFNukeShockwave02/UEFNukeShockwave02_proj.bp', X * OffsetMod , 2.5, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity)
            table.insert( projectiles, proj )
        end  
        
        WaitSeconds( 3 )

        # Slow projectiles down to normal speed
        for k, v in projectiles do
            v:SetAcceleration(-0.45)
        end         
    end, 
	
	OnCreate = function(self)
        AWalkingLandUnit.OnCreate(self)
		self.ArmSlider1 = CreateSlider(self, 'Body')
        self.Trash:Add(self.ArmSlider1)
		self.ArmSlider1:SetGoal(0, 1000, 0)
		self.ArmSlider1:SetSpeed(1000)
		self:HideBone('Body', true) 
        self:SetUnSelectable(true)	
        self:HideBone('Leg01_Turret', true)
        self:HideBone('Leg02_Turret', true)        
        self:HideBone('Leg03_Turret', true)   
        self:HideBone('Leg04_Turret', true) 
        self:HideBone('L_Turret01', true)
        self:HideBone('L_Turret02', true)        
        self:HideBone('R_Turret01', true)   
        self:HideBone('R_Turret02', true)   
		--[[
        if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(0)
		]]--		
    end,
	
	
	 OnStopBeingBuilt = function(self,builder,layer)
        AWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:DisableShield()
		local army = self:GetArmy()
        local position = self:GetPosition()
		local orientation = RandomFloat(0,2*math.pi)
        self:ForkThread(function() 
		WaitSeconds(5)			
		self.ArmSlider1 = CreateSlider(self, 'Body')
		self.Trash:Add(self.ArmSlider1)
		self.ArmSlider1:SetGoal(0, -1000, 0)
		self.ArmSlider1:SetSpeed(500)
		self:ShowBone('Body', true) 
        self:HideBone('Leg01_Turret', true)
        self:HideBone('Leg02_Turret', true)        
        self:HideBone('Leg03_Turret', true)   
        self:HideBone('Leg04_Turret', true) 
        self:HideBone('L_Turret01', true)
        self:HideBone('L_Turret02', true)        
        self:HideBone('R_Turret01', true)   
        self:HideBone('R_Turret02', true)  
		WaitSeconds(2)			
        DamageRing(self, position, .1, 11, 100, 'Force', false, false)
		# Knockdown force rings
        DamageRing(self, position, 11, 20, 1, 'Force', false, false)
        DamageRing(self, position, 11, 20, 1, 'Force', false, false)
        CreateDecal(position, orientation, 'nuke_scorch_002_albedo', '', 'Albedo', 28, 28, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 28, 28, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 12, 12, 500, 600, army) 
		self:CreateOuterRingWaveSmokeRing()
        self:SetUnSelectable(false)	
		self:EnableShield()		
        # Scorch decal and light some trees on fire
        DamageRing(self, position, 20, 27, 1, 'Fire', false, false)
		local bp = self:GetBlueprint()
        for i, numWeapons in bp.Weapon do
            if(bp.Weapon[i].Label == 'WalkerArrival') then
                DamageArea(self, self:GetPosition(), bp.Weapon[i].DamageRadius, bp.Weapon[i].Damage, bp.Weapon[i].DamageType, bp.Weapon[i].DamageFriendly)
                break
            end
        end		
		end)	
        --[[
        if self.AnimationManipulator then
            self:SetUnSelectable(true)
            self.AnimationManipulator:SetRate(1)
            
            self:ForkThread(function()
                WaitSeconds(self.AnimationManipulator:GetAnimationDuration()*self.AnimationManipulator:GetRate())
                self:SetUnSelectable(false)
                self.AnimationManipulator:Destroy()
            end)
        end
		]]--
    end,
}

TypeClass = CSKAL0400