
local SingleBeamProjectile = import('/lua/sim/defaultprojectiles.lua').SingleBeamProjectile2


DEL0204_Parachute = Class(SingleBeamProjectile) {
    
			
			
    OnCreate = function(self)
		SingleBeamProjectile.OnCreate(self)
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
            local location = self:GetPosition('AttachPoint')
			local paratrooper = CreateUnitHPR('DEL0204', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
            paratrooper:AttachTo(self, 'AttachPoint')
			paratrooper:DestroyMovementEffects()
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
    end,			
	
    
	
	BeamName = '/mods/Commander Survival Kit/effects/emitters/empty_exhaust_beam_emit.bp',

	
	
    OnImpact = function(self, TargetType, targetEntity)	
            local location = self:GetPosition('AttachPoint')
			local rotation = self:GetOrientation()
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			local chute = CreateUnitHPR('Paracute_Dummy_02', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
        self:DetachAll('AttachPoint',false)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		SingleBeamProjectile.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = DEL0204_Parachute
