
local SingleBeamProjectile = import('/lua/sim/defaultprojectiles.lua').SingleBeamProjectile2


UEL0111_Parachute = Class(SingleBeamProjectile) {
    
			
			
    OnCreate = function(self)
		SingleBeamProjectile.OnCreate(self)
            local location = self:GetPosition('AttachPoint')
			local paratrooper = CreateUnitHPR('UEL0111', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
            paratrooper:AttachTo(self, 'AttachPoint')
			paratrooper:DestroyMovementEffects()
    end,
	
    
	
	BeamName = '/mods/Commander Survival Kit/effects/emitters/empty_exhaust_beam_emit.bp',

	
	
    OnImpact = function(self, TargetType, targetEntity)	
            local location = self:GetPosition('AttachPoint')
			local rotation = self:GetOrientation()
			local chute = CreateUnitHPR('Paracute_Dummy_02', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			
        self:DetachAll('AttachPoint',false)
		SingleBeamProjectile.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = UEL0111_Parachute
