#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0303/URL0303_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local Weapon = import('/lua/sim/Weapon.lua').Weapon
local cWeapons = import('/lua/cybranweapons.lua')
local CDFElectronBolterWeapon = cWeapons.CDFElectronBolterWeapon
local CDFBrackmanCrabHackPegLauncherWeapon = cWeapons.CDFBrackmanCrabHackPegLauncherWeapon
local CIFMissileLoaWeapon = cWeapons.CIFMissileLoaWeapon
local CAAMissileNaniteWeapon = cWeapons.CAAMissileNaniteWeapon
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone
local EffectTemplate = import('/lua/EffectTemplates.lua')
local utilities = import('/lua/Utilities.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local Entity = import('/lua/sim/Entity.lua').Entity


CSKCL0405 = Class(CWalkingLandUnit) 
{
    PlayEndAnimDestructionEffects = false,

    Weapons = {
        MainGun = Class(CDFElectronBolterWeapon) {},
		HackPegLauncher= Class(CDFBrackmanCrabHackPegLauncherWeapon){},
		MissileRack = Class(CIFMissileLoaWeapon) {},
		AAMissile1 = Class(CAAMissileNaniteWeapon) {},
    },

	BpId = 'cskcl0405',
	
	OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		local bpDisplay = __blueprints[self.BpId].Display
		self:StartSpecAnim(bpDisplay.AnimationsIdle.TotalIdle.Animation, bpDisplay.AnimationsIdle.TotalIdle.Rate, 'IdleAnimator', 'FinishIdleLoop')
        if self.AnimationManipulator then
            self:SetUnSelectable(true)
            self.AnimationManipulator:SetRate(1)
            
            self:ForkThread(function()
                WaitSeconds(self.AnimationManipulator:GetAnimationDuration()*self.AnimationManipulator:GetRate())
                self:SetUnSelectable(false)
                self.AnimationManipulator:Destroy()
            end)
        end        
        self:SetMaintenanceConsumptionActive()
        local layer = self:GetCurrentLayer()
        # If created with F2 on land, then play the transform anim.
        if(layer == 'Land') then
            self:CreateUnitAmbientEffect(layer)
        elseif (layer == 'Seabed') then
            self:CreateUnitAmbientEffect(layer)
        end
        self.WeaponsEnabled = true
    end,

	OnLayerChange = function(self, new, old)
		CWalkingLandUnit.OnLayerChange(self, new, old)
		if self.WeaponsEnabled then
			if( new == 'Land' ) then
			    self:CreateUnitAmbientEffect(new)
			elseif ( new == 'Seabed' ) then
			    self:CreateUnitAmbientEffect(new)
			end
		end
	end,
	
	OnMotionHorzEventChange = function(self, new, old)
        --LOG(new)
        CWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
        if new == 'Stopped' then
            self.LastActive = GetGameTimeSeconds()
            self:UpdateMovementAnimation(new, old, true)
            self:UpdateMovementAnimation(new, old)
            if (not self.DeathAnim or not self.Dead) and not self.FinishMovementLoop then
                if self.Animator then
                    self.Animator:Destroy()
                end
                self.Animator = nil
            end
        elseif new ~= 'Stopped' then
            self:UpdateMovementAnimation(new, old)
        end
    end,
	
	StartSpecAnim = function(self, anim, rate, handler, tracker, unlooped)
        if tracker then
            self[tracker] = unlooped
        end
        if self['Grace'..handler] then KillThread(self['Grace'..handler]) end
        if not self[handler] then
            if handler == 'Animator' then
                self.Animator = CreateAnimator(self, true) 
            else
                self[handler] = CreateAnimator(self)
            end
        end
        local animT
        if not self.TransformThread then 
            animT = self[handler]:GetAnimationTime()
        end
        self[handler]:PlayAnim(anim, not unlooped)
        if not self.TransformThread then
            self[handler]:SetAnimationTime(animT)
        end
        self[handler]:SetDirectionalAnim(handler ~= 'IdleAnimator')
        self[handler]:SetRate(rate)
    end,
	
	UpdateMovementAnimation = function(self, new, old, idle)
        local CheckHeadingForwards = function(self)
            --Returns true if heading forwards
            local vx, vy, vz = self:GetVelocity()
            local head = self:GetHeading()
            if vx == 0 then
                local ahead = math.abs(head)
                if vy < 0 and ahead > 1.57 then
                    return true
                elseif vy > 0 and ahead < 1.57 then
                    return true
                else
                    return false
                end
            elseif vx < 0 and head < 0 then
                return true
            elseif vx > 0 and head > 0 then
                return true
            else
                return false
            end
        end

        local layer = self:GetCurrentLayer()
        local bpDisplay = __blueprints[self.BpId].Display

        if not idle then
            if layer == 'Land' or layer == 'Seabed' then
                if self.TallStance then
				elseif new == 'TopSpeed' or new == 'Cruise' then
                    self:StartSpecAnim(bpDisplay.AnimationsMove.Walk, bpDisplay.AnimationWalkRate, 'Animator', 'FinishMovementLoop')
                elseif new == 'Stopped' then
					self:StartSpecAnim(bpDisplay.AnimationsIdle.TotalIdle.Animation, bpDisplay.AnimationsIdle.TotalIdle.Rate, 'IdleAnimator', 'FinishIdleLoop')
                end
			end
        end
    end,
	
	AmbientExhaustBones = {
		'Effect01',
		'Effect02',
    },	
    
    AmbientLandExhaustEffects = {
		'/effects/emitters/dirty_exhaust_smoke_02_emit.bp',
		'/effects/emitters/dirty_exhaust_sparks_02_emit.bp',			
	},
	
    AmbientSeabedExhaustEffects = {
		'/effects/emitters/underwater_vent_bubbles_02_emit.bp',			
	},	
	
	CreateUnitAmbientEffect = function(self, layer)
	    if( self.AmbientEffectThread != nil ) then
	       self.AmbientEffectThread:Destroy()
        end	 
        if self.AmbientExhaustEffectsBag then
            EffectUtil.CleanupEffectBag(self,'AmbientExhaustEffectsBag')
        end        
        
        self.AmbientEffectThread = nil
        self.AmbientExhaustEffectsBag = {} 
	    if layer == 'Land' then
	        self.AmbientEffectThread = self:ForkThread(self.UnitLandAmbientEffectThread)
	    elseif layer == 'Seabed' then
	        local army = self:GetArmy()
			for kE, vE in self.AmbientSeabedExhaustEffects do
				for kB, vB in self.AmbientExhaustBones do
					table.insert( self.AmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE ))
				end
			end	        
	    end          
	end, 
	
	UnitLandAmbientEffectThread = function(self)
		while not self:IsDead() do
            local army = self:GetArmy()			
			
			for kE, vE in self.AmbientLandExhaustEffects do
				for kB, vB in self.AmbientExhaustBones do
					table.insert( self.AmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE ))
				end
			end
			
			WaitSeconds(2)
			EffectUtil.CleanupEffectBag(self,'AmbientExhaustEffectsBag')
							
			WaitSeconds(utilities.GetRandomFloat(1,7))
		end		
	end,

}

TypeClass = CSKCL0405