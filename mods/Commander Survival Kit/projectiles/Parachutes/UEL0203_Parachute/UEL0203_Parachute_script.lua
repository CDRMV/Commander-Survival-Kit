
local SingleBeamProjectile = import('/lua/sim/defaultprojectiles.lua').SingleBeamProjectile2


UEL0203_Parachute = Class(SingleBeamProjectile) {
    
			
			
    OnCreate = function(self)
		SingleBeamProjectile.OnCreate(self)
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
            local location = self:GetPosition('AttachPoint')
			local paratrooper = CreateUnitHPR('UEL0203', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
            paratrooper:AttachTo(self, 'AttachPoint')
			paratrooper:DestroyMovementEffects()
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
    end,
	
    
	
	BeamName = '/mods/Commander Survival Kit/effects/emitters/empty_exhaust_beam_emit.bp',

	
	
    OnImpact = function(self, TargetType, targetEntity)	
	SetIgnoreArmyUnitCap(self:GetArmy(), true)
            local location = self:GetPosition('AttachPoint')
			local rotation = self:GetOrientation()
			local chute = CreateUnitHPR('Paracute_Dummy_02', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			
        self:DetachAll('AttachPoint',false)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		SingleBeamProjectile.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = UEL0203_Parachute
