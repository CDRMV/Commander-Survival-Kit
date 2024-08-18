#****************************************************************************
#**
#**  File     :  /projectiles/CIFNeutronClusterBomb01/CIFNeutronClusterBomb01.lua
#**  Author(s):  Gordon Duclos
#**
#**  Summary  :  Cybran Neutron Cluster bomb
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TDFCargoProjectile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsProjectiles.lua').TDFCargoProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
local EffectTemplate = import('/lua/EffectTemplates.lua')

TDFCargoDroppod = Class(TDFCargoProjectile) {

 OnImpact = function(self, TargetType, targetEntity)

		TDFCargoProjectile.OnImpact( self, TargetType, targetEntity )
		if TargetType == 'Terrain' then
			local location = self:GetPosition()
			local ShieldUnit =CreateUnitHPR('UEB5105', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
		else
		
        end
   end,
}

TypeClass = TDFCargoDroppod

