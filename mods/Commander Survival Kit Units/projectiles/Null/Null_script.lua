#
# Null projectile
#

Null = Class(import('/lua/terranprojectiles.lua').TShellRiotProjectileLand) { 
    PolyTrails = {'/mods/Commander Survival Kit Units/effects/emitters/Null_polytrail_emit.bp'},
    PolyTrailOffset = {0.05,0.05,0.05},
    FxTrails = {'/mods/Commander Survival Kit Units/effects/emitters/Null_munition_emit.bp'},
    RandomPolyTrails = 1,
    FxImpactUnit = {},
    FxImpactProp = {},
    FxImpactLand = {},
    FxImpactUnderWater = {}, 
}

TypeClass = Null

