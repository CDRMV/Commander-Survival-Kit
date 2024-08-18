#
# script for projectile BoneAttached
#
local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

Blu3000EffectShockwave02 = Class(EmitterProjectile) {
    FxTrails = {'/effects/emitters/nuke_blanket_smoke_01_emit.bp',},
    FxTrailScale = 0.5,
    FxTrailOffset = 0,
}

TypeClass = Blu3000EffectShockwave02