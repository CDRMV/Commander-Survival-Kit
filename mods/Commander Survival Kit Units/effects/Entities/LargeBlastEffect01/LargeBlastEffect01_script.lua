

local NullShell = import("/lua/sim/defaultprojectiles.lua").NullShell
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

LargeBlastEffect01 = Class(NullShell) {

	OnCreate = function(self)
		NullShell.OnCreate(self)
		
		self:ForkThread(self.EffectThread)
	end,

	
	EffectThread = function(self)
        local position = self:GetPosition()

       
      
        local scale = 1.5
		local shockwavescale = 5
		local number = 0
		while true do
		if number == 10 then
		self:Destroy()
		else
		local scaleChange = 20 * scale
		shockwavescale = shockwavescale + 1
		--DamageRing(self, position, 0.01, shockwavescale, 10, 'Nuke', true, true)
		DamageRing(self, position, 0.01, shockwavescale, 1, 'Force', true, true)
		self:SetScaleVelocity(scaleChange, scaleChange, scaleChange)
		number = number +1
		end
		WaitSeconds(0.1)
		end
        
    end,

}
TypeClass = LargeBlastEffect01