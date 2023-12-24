#
# Cybran "Loa" Tactical Missile, mobile unit launcher variant of this missile,
# lower and straighter trajectory. Splits into child projectile if it takes enough
# damage.
#
local CDFPhotonicProjectile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsProjectiles.lua').PhotonicProjectile
CIFPhotonic01 = Class(CDFPhotonicProjectile) {
    
    OnImpact = function(self, targetType, targetEntity)
             # Play the explosion sound
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Explosion then
                self:PlaySound(myBlueprint.Audio.Explosion)
            end
    
            nukeProjectile = self:CreateProjectile('/mods/Commander Survival Kit Units/projectiles/CIFPhotonicExplosion01/CIFPhotonicExplosion01_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
            nukeProjectile:PassDamageData(self.DamageData)
            nukeProjectile:PassData(self.Data)
        CDFPhotonicProjectile.OnImpact(self, targetType, targetEntity)
    end,        
    

}
TypeClass = CIFPhotonic01

