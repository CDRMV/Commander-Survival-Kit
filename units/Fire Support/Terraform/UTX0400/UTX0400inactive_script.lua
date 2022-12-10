#****************************************************************************
#**
#**  UEF Medium Artillery Strike
#**  Author(s):  CDRMV
#**
#**  Summary  :  A Dummy Unit which fires Artillery Strikes below it. 
#**				 It is Selectable and Untargetable by enemy Units.				
#**				 It attacks enemy Units automatically in Range and will be destroyed after 10 Seconds.
#**              
#**  Copyright © 2022 Fire Support Manager by CDRMV
#****************************************************************************

local StructureUnit = import('/lua/defaultunits.lua').StructureUnit
local DefaultProjectileWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon
local ModEffectpath = '/mods/Commander Survival Kit/effects/emitters/'
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

UTX0400inactive = Class(StructureUnit) {
    Weapons = {
        Turret01 = Class(DefaultProjectileWeapon) {},
    },
	
    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
		self:ForkThread(
            function()
				WaitSeconds(600)
			    local bp = self:GetBlueprint()
				local bpAnim = bp.Display.AnimationOpen
				if not bpAnim then return end
				if not self.OpenAnim then
				self.OpenAnim = CreateAnimator(self)
				self.OpenAnim:PlayAnim(bpAnim)
				self.Trash:Add(self.OpenAnim)
				end
				self.OpenAnim:SetRate(0.02)
				self:Destroy()
            end
        )
    end,

}

TypeClass = UTX0400inactive