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

UTX0400 = Class(StructureUnit) {
    Weapons = {
        Turret01 = Class(DefaultProjectileWeapon) {},
    },
	
    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
        self.Effect1 = CreateAttachedEmitter(self,'Crater',self:GetArmy(), ModEffectpath .. 'vulcano_smoke_01_emit.bp'):ScaleEmitter(10):OffsetEmitter(0,-10,0)
        self.Trash:Add(self.Effect1)
		self.Effect2 = CreateAttachedEmitter(self,'Crater',self:GetArmy(), ModEffectpath .. 'vulcano_smoke_01_emit.bp'):ScaleEmitter(10):OffsetEmitter(0,-10,0)
        self.Trash:Add(self.Effect2)
		self.Effect3 = CreateAttachedEmitter(self,'Eruption1',self:GetArmy(), ModEffectpath .. 'lava_fontaene_01_emit.bp'):ScaleEmitter(7):OffsetEmitter(0,-5,0)
        self.Trash:Add(self.Effect3)
		local orientation = RandomFloat(0,2*math.pi)
		local position = self:GetPosition()
        CreateDecal(position, orientation, 'Crater01_albedo', '', 'Albedo', 10, 10, 1200, 0, self:GetArmy())
		self:ForkThread(
            function()
			    local bp = self:GetBlueprint()
				local bpAnim = bp.Display.AnimationOpen
				if not bpAnim then return end
				if not self.OpenAnim then
				self.OpenAnim = CreateAnimator(self)
				self.OpenAnim:PlayAnim(bpAnim)
				self.Trash:Add(self.OpenAnim)
				end
				self.OpenAnim:SetRate(0.02)
                self.AimingNode = CreateRotator(self, 0, 'x', 0, 10000, 10000, 1000)
                WaitFor(self.AimingNode)
				local interval = 0
                while (interval < 61) do
				LOG(interval)
					if interval == 60 then 
								CreateUnitHPR('UTX0400inactive', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
								self:Destroy()
					end
                    local num = Ceil((R()+R()+R()+R()+R()+R()+R()+R()+R()+R()+R())*R(1,10))
                    coroutine.yield(num)
                    self:GetWeaponByLabel'Turret01':FireWeapon()
					interval = interval + 1
                end
            end
        )
    end,

}

TypeClass = UTX0400