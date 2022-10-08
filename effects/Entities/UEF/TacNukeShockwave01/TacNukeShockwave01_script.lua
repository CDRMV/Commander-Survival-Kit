#
# script for projectile BoneAttached
#
local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

TacNukeShockwave01 = Class(EmitterProjectile) {
    FxTrails = {'/effects/emitters/nuke_blanket_smoke_02_emit.bp',},
    FxTrailScale = 0.25,
    FxTrailOffset = 0,
}

TypeClass = TacNukeShockwave01