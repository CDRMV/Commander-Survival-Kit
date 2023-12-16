#****************************************************************************
#**
#**  File     :  /cdimage/units/URA0203/URA0203_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Gunship Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CAirUnit = import('/lua/defaultunits.lua').AirUnit
local cWeapons = import('/lua/cybranweapons.lua')
local CDFRocketIridiumWeapon = cWeapons.CDFRocketIridiumWeapon
local CDFHeavyMicrowaveLaserGeneratorCom = cWeapons.CDFHeavyMicrowaveLaserGeneratorCom
local CDFLaserDisintegratorWeapon = cWeapons.CDFLaserDisintegratorWeapon01

CSKCA0200 = Class(CAirUnit) {
    Weapons = {
	    MainGun = Class(CDFHeavyMicrowaveLaserGeneratorCom) {},
        Missile01 = Class(CDFRocketIridiumWeapon) {},
				Disintegrator = Class(CDFLaserDisintegratorWeapon) {
            OnCreate = function(self)
                CDFLaserDisintegratorWeapon.OnCreate(self)
                #Disable buff 
                self:DisableBuff('STUN')
            end,
        },
    },

    DestructionPartsChassisToss = {'URA0203',},
    #DestructionPartsHighToss = {'Spinner', 'Front_Turret',},

BpId = 'cskca0200',

    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
		local bpDisplay = __blueprints[self.BpId].Display
		self:StartSpecAnim(bpDisplay.AnimationsFly.TotalFly.Animation, bpDisplay.AnimationsFly.TotalFly.Rate, 'IdleAnimator', 'FinishIdleLoop')
        if self.AnimationManipulator then
            self:SetUnSelectable(true)
            self.AnimationManipulator:SetRate(1)
            
            self:ForkThread(function()
                WaitSeconds(self.AnimationManipulator:GetAnimationDuration()*self.AnimationManipulator:GetRate())
                self:SetUnSelectable(false)
                self.AnimationManipulator:Destroy()
            end)
        end        
        #self.Rotator = CreateRotator(self, 'Spinner', 'y', nil, 1000, 0, 0)
        #self.Trash:Add(self.Rotator)
    end,

    OnMotionVertEventChange = function(self, new, old)
        CAirUnit.OnMotionVertEventChange(self, new, old)
        self.AnimManip = CreateAnimator(self)
        self.Trash:Add(self.AnimManip)
        # We want to keep the ambient sound of the rotor
        # playing during the landing sequence
        if new == 'Top' and old == 'Down' or old == 'Bottom' then
		self.AnimManip:SetRate(-1)
		elseif new == 'Down' then
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationLand, false):SetRate(1.5)
		local bpDisplay = __blueprints[self.BpId].Display
		self:StartSpecAnim(bpDisplay.AnimationsFly.TotalFly.Animation, 1, 'IdleAnimator', 'FinishIdleLoop')
        if self.AnimationManipulator then
            self:SetUnSelectable(true)
            self.AnimationManipulator:SetRate(1)
            
            self:ForkThread(function()
                WaitSeconds(self.AnimationManipulator:GetAnimationDuration()*self.AnimationManipulator:GetRate())
                self:SetUnSelectable(false)
                self.AnimationManipulator:Destroy()
            end)
        end 
            # Keep the ambient hover sound going
            self:PlayUnitAmbientSound('AmbientMove')

        elseif new == 'Bottom' then
		local bpDisplay = __blueprints[self.BpId].Display
		self:StartSpecAnim(bpDisplay.AnimationsFly.Idle, 1, 'IdleAnimator', 'FinishIdleLoop')
        if self.AnimationManipulator then
            self:SetUnSelectable(true)
            self.AnimationManipulator:SetRate(1)
            
            self:ForkThread(function()
                WaitSeconds(self.AnimationManipulator:GetAnimationDuration()*self.AnimationManipulator:GetRate())
                self:SetUnSelectable(false)
                self.AnimationManipulator:Destroy()
            end)
        end 
	
        elseif new == 'Up' then
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTakeOff, false):SetRate(1)
		local bpDisplay = __blueprints[self.BpId].Display
		self:StartSpecAnim(bpDisplay.AnimationsFly.TotalFly.Animation, bpDisplay.AnimationsFly.TotalFly.Rate, 'IdleAnimator', 'FinishIdleLoop')
        if self.AnimationManipulator then
            self:SetUnSelectable(true)
            self.AnimationManipulator:SetRate(1)
            
            self:ForkThread(function()
                WaitSeconds(self.AnimationManipulator:GetAnimationDuration()*self.AnimationManipulator:GetRate())
                self:SetUnSelectable(false)
                self.AnimationManipulator:Destroy()
            end)
        end 
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

    #TakingOff = function(self)
    #    self:SetImmobile(true)
    #    self.Rotator:SetSpinDown(false):SetTargetSpeed(1000):SetAccel(500)
    #    WaitFor(self.Rotator)
    #    self:SetImmobile(false)
    #end,
}

TypeClass = CSKCA0200