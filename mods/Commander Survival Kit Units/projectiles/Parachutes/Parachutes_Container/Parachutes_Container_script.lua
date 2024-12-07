
local SingleBeamProjectile = import('/lua/sim/defaultprojectiles.lua').SingleBeamProjectile2


Parachutes_Container = Class(SingleBeamProjectile) {
    
			
			
    OnCreate = function(self)
		SingleBeamProjectile.OnCreate(self)
            local location = self:GetPosition('AttachPoint')
			local paratrooper = CreateUnitHPR('UEL0101', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
            paratrooper:AttachTo(self, 'AttachPoint')
    end,
	
    
	
	
	
    OnImpact = function(self, TargetType, targetEntity)	
            local location = self:GetPosition('AttachPoint')
			local rotation = self:GetOrientation()
			local chute = CreateUnitHPR('Paracute_Dummy_02', self:GetArmy(), location[1], location[2], location[3], 0, rotation[2], 0)
			
        self:DetachAll('AttachPoint',false)
		SingleBeamProjectile.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = Parachutes_Container
