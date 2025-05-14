local WeaponFile = import('/lua/sim/DefaultWeapons.lua')
local KamikazeWeapon = WeaponFile.KamikazeWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

TAmunitionWeapon = Class(KamikazeWeapon){
	FxDeath = EffectTemplate.TAPDSHit01,
	FxDeath2 = EffectTemplate.CMobileKamikazeBombExplosion,
    OnFire = function(self)
		local army = self.unit:GetArmy()
        for k, v in self.FxDeath do
            CreateEmitterAtBone(self.unit,-2,army,v):ScaleEmitter(1)
        end 
		for k, v in self.FxDeath2 do
            CreateEmitterAtBone(self.unit,-2,army,v):ScaleEmitter(1.5)
        end 
        CreateLightParticle( self.unit, -1, -1, 15, 10, 'flare_lens_add_02', 'ramp_red_10' ) 
		KamikazeWeapon.OnFire(self)
    end,
}




