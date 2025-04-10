

local NullShell = import("/lua/sim/defaultprojectiles.lua").NullShell
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'

DimensionalBlastEffect01 = Class(NullShell) {

	OnCreate = function(self)
		NullShell.OnCreate(self)
		
		self:ForkThread(self.EffectThread)
	end,

	
	EffectThread = function(self)
        local position = self:GetPosition()
        local scale = 1
		local shockwavescale = 0
		local shockwaveemitterscale = 9
		local number = 0
		self.Effect = CreateAttachedEmitter(self,0,self:GetArmy(), ModeffectPath .. 'BlastShockwave_emit.bp'):ScaleEmitter(shockwaveemitterscale)
		while true do
		if number == 10 then
		self:Destroy()
		else
		local scaleChange = 20 * scale
		shockwavescale = shockwavescale + 1
		shockwaveemitterscale = shockwaveemitterscale + 1
		DamageRing(self, position, 0.01, shockwavescale, 10, 'Nuke', true, true)
		DamageRing(self, position, 0.01, shockwavescale, 1, 'Force', true, true)
		self.Effect:ScaleEmitter(shockwaveemitterscale)
		self:SetScaleVelocity(scaleChange, scaleChange, scaleChange)
		number = number +1
		end
		WaitSeconds(0.1)
		end
        
    end,
        
    
}
TypeClass = DimensionalBlastEffect01