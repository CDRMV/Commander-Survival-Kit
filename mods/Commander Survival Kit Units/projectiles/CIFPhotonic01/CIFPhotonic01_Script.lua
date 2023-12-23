#
# Cybran "Loa" Tactical Missile, mobile unit launcher variant of this missile,
# lower and straighter trajectory. Splits into child projectile if it takes enough
# damage.
#
local TDFGaussCannonProjectile = import('/lua/terranprojectiles.lua').TDFGaussCannonProjectile
local ModEffects = '/mods/Commander Survival Kit Units/effects/emitters/'
CIFPhotonic01 = Class(TDFGaussCannonProjectile) {
    OnCreate = function(self)
        TDFGaussCannonProjectile.OnCreate(self)
		self.Effect1 = CreateAttachedEmitter(self, 0, nil, ModEffects .. 'photonic_ambient_01_emit.bp'):ScaleEmitter(2.0):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1)
    end,  
    
    OnImpact = function(self, targetType, targetEntity)
             # Play the explosion sound
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Explosion then
                self:PlaySound(myBlueprint.Audio.Explosion)
            end
    
            nukeProjectile = self:CreateProjectile('/projectiles/CIFEMPFluxWarhead02/CIFEMPFluxWarhead02_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
            nukeProjectile:PassDamageData(self.DamageData)
            nukeProjectile:PassData(self.Data)
        TDFGaussCannonProjectile.OnImpact(self, targetType, targetEntity)
    end,        
    

}
TypeClass = CIFPhotonic01

