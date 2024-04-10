-- Flamethrower Projectile

local CNaniteCloud02 = import('/mods/Commander Survival Kit Units/lua/CSKUnitsProjectiles.lua').CNaniteCloud02
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

CDFNaniteCloud02 = Class(CNaniteCloud02) {
    OnImpact = function(self, TargetType, targetEntity)
		if TargetType != 'Water' then 

		local location = self:GetPosition()
		local ShieldUnit =CreateUnitHPR('URFSSP02XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
		end	 
		CNaniteCloud02.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = CDFNaniteCloud02
