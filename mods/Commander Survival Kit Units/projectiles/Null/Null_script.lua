#
# Terran Riot basic projectile
#
local EffectTemplate = import('/lua/EffectTemplates.lua')

Null = Class(import('/lua/terranprojectiles.lua').TShellRiotProjectileLand) { 
    PolyTrails = {},
    PolyTrailOffset = {},
    FxTrails = {},
    RandomPolyTrails = 1,
    FxImpactUnit = {},
    FxImpactProp = {},
    FxImpactLand = {},
    FxImpactUnderWater = {}, 
}

TypeClass = Null

