#
# script for projectile BoneAttached
#
local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

TacNukeShockwave04 = Class(EmitterProjectile) {
    FxTrails = {'/mods/Commander Survival Kit Units/effects/emitters/tenium_blanket_smoke_03_emit.bp',},
    FxTrailScale = 2,
    FxTrailOffset = 0,
}

TypeClass = TacNukeShockwave04