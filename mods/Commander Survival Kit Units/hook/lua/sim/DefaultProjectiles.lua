do


SingleBeamProjectile2 = Class(EmitterProjectile) {

    BeamName = '/effects/emitters/default_beam_01_emit.bp',
    FxTrails = {},

    OnCreate = function(self)
        EmitterProjectile.OnCreate(self)
        if self.BeamName then
            CreateBeamEmitterOnEntity( self, -1, self:GetArmy(), self.BeamName )
        end
    end,
}


end
