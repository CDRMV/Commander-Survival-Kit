-- Flamethrower Projectile

local Flamethrower02 = import('/mods/Commander Survival Kit Units/lua/CSKUnitsProjectiles.lua').Flamethrower02
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

Flamethrower = Class(Flamethrower02) {
    OnImpact = function(self, TargetType, targetEntity)
		if TargetType != 'Water' then 
			local rotation = RandomFloat(0,2*math.pi)
			local size = RandomFloat(3.75,5.0)
	        
			CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 15, self:GetArmy())
		end	 
		Flamethrower02.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = Flamethrower
