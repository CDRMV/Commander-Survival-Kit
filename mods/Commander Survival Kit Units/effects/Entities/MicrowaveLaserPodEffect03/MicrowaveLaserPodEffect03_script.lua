#****************************************************************************
#**
#**  File     :  /data/projectiles/BrackmanQAIHackCircuitryEffect03/BrackmanQAIHackCircuitryEffect03_script.lua
#**
#**  Author(s):  Greg Kohne
#**
#**  Summary  :  BrackmanQAIHackCircuitryEffect03, non-damaging
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local ModsEffectTemplate = import('/mods/commander Survival kit Units/lua/CSKUnitsEffectTemplates.lua')
local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

MicrowaveLaserPodEffect03 = Class(EmitterProjectile) {
	FxImpactTrajectoryAligned = true,
	FxTrajectoryAligned= true,
	FxTrails = ModsEffectTemplate.CMicrowaveEffect02FxtrailsAll[3],
}
TypeClass = MicrowaveLaserPodEffect03
