

local AWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local WeaponsFile = import("/lua/aeonweapons.lua")
local ADFLaserHighIntensityWeapon = import("/lua/aeonweapons.lua").ADFLaserHighIntensityWeapon
local ADFCannonOblivionWeapon = import("/lua/aeonweapons.lua").ADFCannonOblivionWeapon
local AAAZealotMissileWeapon = import("/lua/aeonweapons.lua").AAAZealotMissileWeapon
local EffectTemplate = import("/lua/effecttemplates.lua")
local EffectUtil = import("/lua/effectutilities.lua")
local explosion = import("/lua/defaultexplosions.lua")

---@class Enforcer : AWalkingLandUnit
CSKAL0304 = Class(AWalkingLandUnit) {
    Weapons = {
        MainGun = Class(ADFCannonOblivionWeapon) {  
			FxMuzzleFlashScale = 0.05,
			FxMuzzleFlash = EffectTemplate.AOblivionCannonChargeMuzzleFlash02,
			FxTrailScale = 10.5,
			FxTrail = EffectTemplate.AOblivionCannonFXTrails02,
		}, 
		SideGun = Class(ADFLaserHighIntensityWeapon) {},		  
        Missile = Class(AAAZealotMissileWeapon) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        AWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)

        if self.AnimationManipulator then
            self:SetUnSelectable(true)
            self.AnimationManipulator:SetRate(1)
            
            self:ForkThread(function()
                WaitSeconds(self.AnimationManipulator:GetAnimationDuration()*self.AnimationManipulator:GetRate())
                self:SetUnSelectable(false)
                self.AnimationManipulator:Destroy()
            end)
        end       
    end,


    OnMotionHorzEventChange = function(self, new, old)
        AWalkingLandUnit.OnMotionHorzEventChange(self, new, old)

        if (old == 'Stopped') then
            local bpDisplay = self:GetBlueprint().Display
            if bpDisplay.AnimationWalk and self.Animator then
                self.Animator:SetDirectionalAnim(true)
                self.Animator:SetRate(bpDisplay.AnimationWalkRate)
            end
        end
    end,
	
	
	
}
TypeClass = CSKAL0304
