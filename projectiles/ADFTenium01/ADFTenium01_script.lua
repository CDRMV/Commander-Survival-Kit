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

ADFTenium01 = Class(ATeniumProjectile) {
		OnImpact = function(self, TargetType, TargetEntity)
			ATeniumProjectile.OnImpact(self, TargetType, TargetEntity)
			if TargetType == 'Shield' then
			    if self.Data > TargetEntity:GetHealth() then
			        Damage(self, {0,0,0}, TargetEntity, TargetEntity:GetHealth(), 'Normal')
			    else
					Damage(self, {0,0,0}, TargetEntity, self.Data, 'Normal')
		        end
			end				
		end,
	}

TypeClass = ADFTenium01

