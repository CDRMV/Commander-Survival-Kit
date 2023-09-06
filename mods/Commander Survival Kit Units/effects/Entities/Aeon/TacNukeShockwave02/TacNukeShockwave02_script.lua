#
# script for projectile BoneAttached
#
local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

TacNukeShockwave02 = Class(EmitterProjectile) {
    FxTrails = {'/mods/Commander Survival Kit Units/effects/emitters/aeon_blanket_smoke_01_emit.bp',},
    FxTrailScale = 0.2,
    FxTrailOffset = 0,
}

TypeClass = TacNukeShockwave02