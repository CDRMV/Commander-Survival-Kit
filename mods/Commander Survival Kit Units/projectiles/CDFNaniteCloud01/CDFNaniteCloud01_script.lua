-- Flamethrower Projectile

local CNaniteCloud01 = import('/mods/Commander Survival Kit Units/lua/CSKUnitsProjectiles.lua').CNaniteCloud01
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

CDFNaniteCloud01 = Class(CNaniteCloud01) {
    OnImpact = function(self, TargetType, targetEntity)
		if TargetType != 'Water' then 

		local location = self:GetPosition()
		local ShieldUnit =CreateUnitHPR('URFSSP03XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
		end	 
		CNaniteCloud01.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = CDFNaniteCloud01
