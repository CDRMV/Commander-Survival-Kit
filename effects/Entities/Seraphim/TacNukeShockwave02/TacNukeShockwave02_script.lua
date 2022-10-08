#
# script for projectile BoneAttached
#
local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

TacNukeShockwave02 = Class(EmitterProjectile) {
    FxTrails = {'/mods/Reinforcement Manager/effects/emitters/snuke_blanket_smoke_01_emit.bp',},
    FxTrailScale = 0.2,
    FxTrailOffset = 0,
}

TypeClass = TacNukeShockwave02