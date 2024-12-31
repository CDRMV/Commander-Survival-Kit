#
# UEF Small Yield Nuclear Bomb
#
local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')

local Explosion = import('/lua/defaultexplosions.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')

local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )
if version < 3652 then 
local NullShell = DefaultProjectileFile.NullShell
CIFEMPFluxBomb01 = Class(NullShell) {
	
    OnImpact = function(self, TargetType, TargetEntity)
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Explosion then
                self:PlaySound(myBlueprint.Audio.Explosion)
            end
			nukeProjectile = self:CreateProjectile('/projectiles/CIFEMPFluxWarhead02/CIFEMPFluxWarhead02_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
            nukeProjectile:PassDamageData(self.DamageData)
            nukeProjectile:PassData(self.Data)
			self:Destroy()
			NullShell.OnImpact(self, TargetType, TargetEntity)
    end,

}

TypeClass = CIFEMPFluxBomb01

else
local NukeProjectile = DefaultProjectileFile.NukeProjectile
CIFEMPFluxBomb01 = Class(NukeProjectile) {
	
	OnCreate = function(self)
        NukeProjectile.OnCreate(self)
        self.effectEntityPath = '/projectiles/CIFEMPFluxWarhead02/CIFEMPFluxWarhead02_proj.bp'
    end,
	
	
	OnImpact = function(self, TargetType, TargetEntity)
		NukeProjectile.OnImpact(self, TargetType, TargetEntity)
    end,

}

TypeClass = CIFEMPFluxBomb01
end
