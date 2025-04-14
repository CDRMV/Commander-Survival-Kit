#****************************************************************************
#**
#**  File     :  /data/projectiles/SIFExperimentalStrategicMissileEffect03/SIFExperimentalStrategicMissileEffect03_script.lua
#**  Author(s):  Matt Vainio
#**
#**  Summary  :  Inaino Strategic Bomb effect script, non-damaging
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEmtPath = '/mods/Commander Survival Kit/effects/emitters/'
KillerAsteroidImpactEffect03 = Class(import('/lua/sim/defaultprojectiles.lua').EmitterProjectile) {


	FxTrails = {
	    ModEmtPath .. 'killer_asteroid_plume_fxtrails_03_emit.bp',	## upwards plasma cloud 
    ModEmtPath .. 'killer_asteroid_plume_fxtrails_04_emit.bp',	## upwards plasma cloud darkening  
	},
}
TypeClass = KillerAsteroidImpactEffect03
