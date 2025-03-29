#****************************************************************************
#**
#**  File     :  /data/projectiles/BrackmanQAIHackCircuitryEffect02/BrackmanQAIHackCircuitryEffect02_script.lua
#**
#**  Author(s):  Greg Kohne
#**
#**  Summary  :  BrackmanQAIHackCircuitryEffect02, non-damaging
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local ModsEffectTemplate = import('/mods/commander Survival Kit/lua/FireSupportEffects.lua')
local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

MicrowaveLaserPodEffect02 = Class(EmitterProjectile) {
	FxImpactTrajectoryAligned = true,
	FxTrajectoryAligned= true,
	FxTrails = ModsEffectTemplate.CMicrowaveEffect02FxtrailsAll[2],
}
TypeClass = MicrowaveLaserPodEffect02
