#
# script for projectile BoneAttached
#
local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

TacNukeShockwave01 = Class(EmitterProjectile) {
    FxTrails = {'/mods/Commander Survival Kit/effects/emitters/aeon_blanket_smoke_01_emit.bp',},
    FxTrailScale = 0.25,
    FxTrailOffset = 0,
}

TypeClass = TacNukeShockwave01