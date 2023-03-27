#
# script for projectile BoneAttached
#
local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

TacNukeShockwave01 = Class(EmitterProjectile) {
    FxTrails = {'/effects/emitters/seraphim_inaino_explode_08_emit.bp',},
    FxTrailScale = 0.25,
    FxTrailOffset = 0,
}

TypeClass = TacNukeShockwave01