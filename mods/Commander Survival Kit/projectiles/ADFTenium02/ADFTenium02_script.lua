#****************************************************************************
#**
#**  File     :  /data/projectiles/ADFShieldDisruptor01/ADFShieldDisruptor01_script.lua
#**  Author(s):  Matt Vainio
#**
#**  Summary  :  Aeon Shield Disruptor Projectile, DAL0310
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local ATeniumProjectile = import('/mods/Commander Survival kit/lua/FireSupportProjectiles.lua').ATeniumProjectile

ADFTenium02 = Class(ATeniumProjectile) {
  OnImpact = function(self, TargetType, TargetEntity)
        if not TargetEntity or not EntityCategoryContains(categories.PROJECTILE, TargetEntity) then
            # Play the explosion sound
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Explosion then
                self:PlaySound(myBlueprint.Audio.Explosion)
            end
           
			nukeProjectile = self:CreateProjectile('/mods/Commander Survival Kit/effects/Entities/ATeniumImpact/TacNukeEffectController02/TacNukeEffectController02_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
            nukeProjectile:PassData(self.Data)
        end
        ATeniumProjectile.OnImpact(self, TargetType, TargetEntity)
    end,    
	}

TypeClass = ADFTenium02

