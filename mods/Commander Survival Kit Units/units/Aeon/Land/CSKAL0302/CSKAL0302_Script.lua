#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0303/UAL0303_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Siege Assault Bot Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local ADFLaserHighIntensityWeapon = import('/lua/aeonweapons.lua').ADFLaserHighIntensityWeapon
local ADFCannonOblivionWeapon = import('/lua/aeonweapons.lua').ADFCannonOblivionWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local EffectTemplate = import('/lua/EffectTemplates.lua')

CSKAL0302 = Class(AWalkingLandUnit) {    
    Weapons = {
		EyeGun = Class(ADFCannonOblivionWeapon) {},
        LegTurrets = Class(ADFLaserHighIntensityWeapon) {},
    },
	
		
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
	
	CreateGroundPlumeConvectionEffects = function(self,army)
    for k, v in EffectTemplate.TNukeGroundConvectionEffects01 do
          CreateEmitterAtEntity(self, army, v ) 
    end
    
    local sides = 10
    local angle = (2*math.pi) / sides
    local inner_lower_limit = 2
        local outer_lower_limit = 2
        local outer_upper_limit = 2
    
    local inner_lower_height = 1
    local inner_upper_height = 3
    local outer_lower_height = 2
    local outer_upper_height = 3
      
    sides = 8
    angle = (2*math.pi) / sides
    for i = 0, (sides-1)
    do
        local magnitude = RandomFloat(outer_lower_limit, outer_upper_limit)
        local x = math.sin(i*angle+RandomFloat(-angle/2, angle/4)) * magnitude
        local z = math.cos(i*angle+RandomFloat(-angle/2, angle/4)) * magnitude
        local velocity = RandomFloat( 1, 3 ) * 3
        self:CreateProjectile('/effects/entities/UEFNukeEffect05/UEFNukeEffect05_proj.bp', x, RandomFloat(outer_lower_height, outer_upper_height), z, x, 0, z)
            :SetVelocity(x * velocity, 0, z * velocity)
    end 
    end,
    
	OnCreate = function(self)
        AWalkingLandUnit.OnCreate(self)
		self:HideBone('CSKAL0402', true) 
		local army = self:GetArmy()
		local position = self:GetPosition()
		local orientation = 0
		decal = CreateDecal(position, orientation, '/mods/Commander Survival Kit Units/icons/aeon_symbol.dds', '', 'Albedo', 15, 15, 500, 600, army)
		self.ArmSlider1 = CreateSlider(self, 'Body')
        self.Trash:Add(self.ArmSlider1)
		self.ArmSlider1:SetGoal(0, 1000, 0)
		self.ArmSlider1:SetSpeed(1000)
        self:SetUnSelectable(true)	
    end,

	
	OnStopBeingBuilt = function(self,builder,layer)
		AWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:HideBone('CSKAL0402', true) 
		decal:Destroy()
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(0)		
		self:DisableShield()
		local army = self:GetArmy()
        local position = self:GetPosition()
		local orientation = RandomFloat(0,2*math.pi)
        self:ForkThread(function() 
		WaitSeconds(5)	
		self.Effect1 = CreateAttachedEmitter(self,'Body',self:GetArmy(), '/effects/emitters/aeon_shield_generator_t2_02_emit.bp')
        self.Trash:Add(self.Effect1)
		self.Effect1:ScaleEmitter(2):OffsetEmitter(0,-1,0)
		self.Effect2 = CreateAttachedEmitter(self,'Body',self:GetArmy(), '/effects/emitters/aeon_shield_generator_t2_03_emit.bp')
        self.Trash:Add(self.Effect2)
		self.Effect2:ScaleEmitter(2):OffsetEmitter(0,-1,0)
		self.ArmSlider1 = CreateSlider(self, 'Body')
		self.Trash:Add(self.ArmSlider1)
		self.ArmSlider1:SetGoal(0, -1000, 0)
		self.ArmSlider1:SetSpeed(500)
		WaitSeconds(2)			
        DamageRing(self, position, .1, 11, 100, 'Force', false, false)
		# Knockdown force rings
        DamageRing(self, position, 11, 20, 1, 'Force', false, false)
        DamageRing(self, position, 11, 20, 1, 'Force', false, false)
        CreateDecal(position, orientation, 'Scorch_010_albedo', '', 'Albedo', 28, 28, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 28, 28, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 12, 12, 500, 600, army)
		if self.AnimationManipulator then
            self:ForkThread(function()
				self.AnimationManipulator:SetRate(0.1)
                WaitSeconds(15)
                self.AnimationManipulator:Destroy()
				self:SetUnSelectable(false)	
            end)
        end	
		self:CreateGroundPlumeConvectionEffects()		
		self:CreateOuterRingWaveSmokeRing()
		self:ShowBone('CSKAL0402', true) 
		self.Effect1:Destroy()		
		self.Effect2:Destroy()
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
    end,
}

TypeClass = CSKAL0302