#****************************************************************************
#**
#**  File     :  /data/projectiles/BrackmanQAIHackCircuitryEffect01/BrackmanQAIHackCircuitryEffect01_script.lua
#**
#**  Author(s):  Greg Kohne
#**
#**  Summary  :  BrackmanQAIHackCircuitryEffect01, non-damaging
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local ModsEffectTemplate = import('/mods/commander Survival kit Units/lua/CSKUnitsEffectTemplates.lua')
local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

MicrowaveLaserPodEffect01 = Class(EmitterProjectile) {
	FxImpactTrajectoryAligned = true,
	FxTrajectoryAligned= true,
	FxTrails = ModsEffectTemplate.CMicrowaveEffect02FxtrailsAll[1],
}
TypeClass = MicrowaveLaserPodEffect01
